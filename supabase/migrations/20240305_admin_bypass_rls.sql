-- Fix for Admin Dashboard RLS issues.
-- Since the Admin Dashboard uses a hardcoded frontend login ("admin" / "12345") 
-- it does not have a Supabase Auth session (auth.uid() is null).
-- The following policies allow the frontend admin to view and moderate reports, jobs, and profiles.
-- NOTE: In a production environment, you should use real Supabase Auth for admins.

-- Allow public selecting and updating of reports for the Admin Dashboard
DROP POLICY IF EXISTS "Admins can view all reports" ON public.reports;
CREATE POLICY "Admins can view all reports" ON public.reports FOR SELECT USING (true);

DROP POLICY IF EXISTS "Admins can update reports" ON public.reports;
CREATE POLICY "Admins can update reports" ON public.reports FOR UPDATE USING (true);

-- Allow admin to update and delete jobs for moderation (e.g. Pause Job, Close Job)
-- Public SELECT already exists for jobs.
CREATE POLICY "Admin can update jobs" ON public.jobs FOR UPDATE USING (true);
CREATE POLICY "Admin can delete jobs" ON public.jobs FOR DELETE USING (true);

-- Allow admin to update profiles (e.g. Suspend/Ban users)
-- Public SELECT already exists for profiles.
CREATE POLICY "Admin can update profiles" ON public.profiles FOR UPDATE USING (true);
