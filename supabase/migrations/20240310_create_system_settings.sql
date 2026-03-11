-- Create system_settings table to store global platform configurations
CREATE TABLE IF NOT EXISTS public.system_settings (
    id TEXT PRIMARY KEY DEFAULT 'global',
    settings JSONB NOT NULL DEFAULT '{
        "newUserReg": true,
        "jobPosting": true,
        "reportAlerts": true,
        "systemActivity": false,
        "globalNotifs": true,
        "strictSecurity": false
    }',
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;

-- Policies (Public for Admin Dashboard access as per current pattern)
-- Note: In production, these should be restricted to authenticated admin users.
DROP POLICY IF EXISTS "Anyone can view system settings" ON public.system_settings;
CREATE POLICY "Anyone can view system settings" ON public.system_settings FOR SELECT USING (true);

DROP POLICY IF EXISTS "Anyone can update system settings" ON public.system_settings;
CREATE POLICY "Anyone can update system settings" ON public.system_settings FOR UPDATE USING (true);

-- Insert default row if not exists
INSERT INTO public.system_settings (id) VALUES ('global') ON CONFLICT (id) DO NOTHING;

-- Add to realtime publication if exists
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
        IF NOT EXISTS (
            SELECT 1 FROM pg_publication_tables 
            WHERE pubname = 'supabase_realtime' 
            AND schemaname = 'public' 
            AND tablename = 'system_settings'
        ) THEN
            ALTER PUBLICATION supabase_realtime ADD TABLE public.system_settings;
        END IF;
    END IF;
END $$;
