-- Enable RLS on jobs if not already enabled
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read active jobs (for worker/guest discovery)
CREATE POLICY IF NOT EXISTS "Anyone can read jobs" ON jobs
  FOR SELECT USING (true);

-- Allow authenticated providers to insert their own jobs
CREATE POLICY IF NOT EXISTS "Providers can insert own jobs" ON jobs
  FOR INSERT WITH CHECK (auth.uid() = provider_id);

-- Allow providers to update their own jobs (THIS WAS THE MISSING POLICY)
CREATE POLICY IF NOT EXISTS "Providers can update own jobs" ON jobs
  FOR UPDATE USING (auth.uid() = provider_id)
  WITH CHECK (auth.uid() = provider_id);

-- Allow providers to delete their own jobs
CREATE POLICY IF NOT EXISTS "Providers can delete own jobs" ON jobs
  FOR DELETE USING (auth.uid() = provider_id);

-- Enable realtime for jobs
ALTER PUBLICATION supabase_realtime ADD TABLE jobs;
