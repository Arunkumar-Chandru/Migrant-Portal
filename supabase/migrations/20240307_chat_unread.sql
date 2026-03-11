-- Migration to add is_read column for chat notifications

ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS is_read BOOLEAN DEFAULT false;

-- Allow users to update is_read status for messages they receive
CREATE POLICY "Users can mark messages as read"
    ON public.messages FOR UPDATE
    USING (auth.uid() = receiver_id)
    WITH CHECK (auth.uid() = receiver_id);
