-- Create reports table
CREATE TABLE IF NOT EXISTS public.reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID NOT NULL REFERENCES public.profiles(id) DEFAULT auth.uid(),
    reported_entity_id UUID NOT NULL,
    entity_type TEXT NOT NULL CHECK (entity_type IN ('worker', 'job')),
    reason TEXT NOT NULL,
    description TEXT,
    proof_url TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'under_review', 'action_taken', 'rejected')),
    admin_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    
    -- Ensure one report per entity per reporter
    UNIQUE(reporter_id, reported_entity_id, entity_type)
);

-- Add moderation columns to profiles
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS is_suspended BOOLEAN DEFAULT false;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS is_banned BOOLEAN DEFAULT false;

-- Enable RLS
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

-- RLS Policies for reports
CREATE POLICY "Users can create reports" 
    ON public.reports FOR INSERT 
    WITH CHECK (auth.uid() = reporter_id);

CREATE POLICY "Users can view their own reports" 
    ON public.reports FOR SELECT 
    USING (auth.uid() = reporter_id);

CREATE POLICY "Admins can view all reports" 
    ON public.reports FOR SELECT 
    USING (
        EXISTS (
            SELECT 1 FROM public.user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

CREATE POLICY "Admins can update reports" 
    ON public.reports FOR UPDATE 
    USING (
        EXISTS (
            SELECT 1 FROM public.user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

-- Create storage bucket for report proof if not exists
-- Note: This might require manual setup in Supabase UI or using a separate RPC if extensions are not available
-- Inserting into storage.buckets is sometimes restricted via SQL
INSERT INTO storage.buckets (id, name, public)
VALUES ('report-proofs', 'report-proofs', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for report-proofs bucket
CREATE POLICY "Public Access" ON storage.objects FOR SELECT USING (bucket_id = 'report-proofs');
CREATE POLICY "Authenticated users can upload proof" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'report-proofs' AND auth.role() = 'authenticated');
