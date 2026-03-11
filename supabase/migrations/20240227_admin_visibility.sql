-- Allow everyone (including the Admin Dashboard frontend) to see user roles
-- This is necessary for the Admin Dashboard to categorize users correctly
CREATE POLICY "Public profiles are viewable by everyone" ON profiles
  FOR SELECT USING (true);

-- Allow everyone to see roles
CREATE POLICY "Public user_roles are viewable by everyone" ON user_roles
  FOR SELECT USING (true);

-- Allow everyone to see provider profiles
CREATE POLICY "Public provider_profiles are viewable by everyone" ON provider_profiles
  FOR SELECT USING (true);

-- If policies already exist with different names, you might need to drop them first or use:
-- DROP POLICY IF EXISTS "..." ON ...;
-- CREATE POLICY ...
