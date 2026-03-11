-- Migration for Chat Feature and Enhanced Reporting

-- Create messages table for chat between workers and providers
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id UUID NOT NULL REFERENCES public.jobs(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    receiver_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS for messages
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- Messages policies
-- Users can only see messages where they are either the sender or the receiver
CREATE POLICY "Users can view their own messages"
    ON public.messages FOR SELECT
    USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- Users can only insert messages where they are the sender
CREATE POLICY "Users can send messages"
    ON public.messages FOR INSERT
    WITH CHECK (auth.uid() = sender_id);

-- Admins can view all messages for evidence review
CREATE POLICY "Admins can view all messages"
    ON public.messages FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.user_roles 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

-- Update reports table for chat integration and better context
ALTER TABLE public.reports ADD COLUMN IF NOT EXISTS job_id UUID REFERENCES public.jobs(id);
ALTER TABLE public.reports ADD COLUMN IF NOT EXISTS chat_evidence JSONB;

-- Realtime for messages (ensure it's added to the publication)
-- Note: In some Supabase setups, you might need to use:
-- ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
-- But typically handled via UI or existing publication
do $$
begin
  if not exists (select 1 from pg_publication_tables where tablename = 'messages' and pubname = 'supabase_realtime') then
    alter publication supabase_realtime add table public.messages;
  end if;
end $$;
