-- Allow providers to update the status of job applications for their own jobs
-- This is necessary for accepting or rejecting applicants
CREATE POLICY "Providers can update application status" ON job_applications
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM jobs
      WHERE jobs.id = job_applications.job_id
      AND jobs.provider_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM jobs
      WHERE jobs.id = job_applications.job_id
      AND jobs.provider_id = auth.uid()
    )
  );

-- Enable Realtime for job_applications to ensure workers receive instant notifications
ALTER PUBLICATION supabase_realtime ADD TABLE job_applications;
