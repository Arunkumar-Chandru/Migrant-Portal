-- Create notifications table for system messages (warnings, resolutions)
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'system',
    link TEXT,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Note: We don't enforce foreign key on user_id to auth.users because we might notify users 
-- who were created via other means, or we just want to be flexible.

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Allow anyone to insert (so the frontend admin dashboard can create notifications)
CREATE POLICY "Anyone can insert notifications" ON public.notifications FOR INSERT WITH CHECK (true);

-- Allow users to view their own notifications
CREATE POLICY "Users can view own notifications" ON public.notifications FOR SELECT USING (auth.uid() = user_id);

-- Enable realtime for notifications
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
