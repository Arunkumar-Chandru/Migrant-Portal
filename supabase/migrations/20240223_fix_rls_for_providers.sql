-- Allow providers to view job applications for their own jobs
CREATE POLICY "Providers can view applications for their jobs" ON job_applications
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM jobs
      WHERE jobs.id = job_applications.job_id
      AND jobs.provider_id = auth.uid()
    )
  );

-- Allow providers to view profiles of workers who applied to their jobs
CREATE POLICY "Providers can view applicant profiles" ON profiles
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM job_applications
      JOIN jobs ON job_applications.job_id = jobs.id
      WHERE job_applications.worker_id = profiles.id
      AND jobs.provider_id = auth.uid()
    )
  );
