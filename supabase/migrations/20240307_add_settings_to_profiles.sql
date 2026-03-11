-- Add settings columns to profiles (Worker)
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS notification_settings JSONB DEFAULT '{"jobMatches": true, "appUpdates": true, "accAlerts": true, "dndMode": false}';

-- Add settings columns to provider_profiles (Provider)
ALTER TABLE public.provider_profiles 
ADD COLUMN IF NOT EXISTS notification_settings JSONB DEFAULT '{"newApplicantAlerts": true, "shortlistedWorkerUpdates": true, "jobStatusReminders": true, "dndMode": false}';

ALTER TABLE public.provider_profiles 
ADD COLUMN IF NOT EXISTS job_management_settings JSONB DEFAULT '{"autoPause": true, "duplicateJob": false, "autoArchive": true}';

-- Enable realtime for the tables if not already enabled
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' 
        AND schemaname = 'public' 
        AND tablename = 'profiles'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE profiles;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' 
        AND schemaname = 'public' 
        AND tablename = 'provider_profiles'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE provider_profiles;
    END IF;
END $$;
