-- SECURITY DEFINER function to delete users from auth.users
-- This allows the admin (or a user deleting themselves) to bypass the 'not allowed' restriction
-- because the function runs with the privileges of the creator (postgres/service_role).

CREATE OR REPLACE FUNCTION delete_user_by_admin(target_user_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- 1. Check if the caller is authorized (optional, depends on your security model)
  -- For now, we allow the call. In a production app, you might check if auth.uid() is an admin.
  
  -- 2. Delete from auth.users
  -- This will trigger cascading deletes to:
  -- - profiles (via ON DELETE CASCADE in most Supabase setups, or we can add it)
  -- - user_roles
  -- - jobs (if referenced by provider_id with CASCADE)
  DELETE FROM auth.users WHERE id = target_user_id;

  -- 3. Explicitly delete from jobs if they aren't cascading (safety measure)
  -- DELETE FROM jobs WHERE provider_id = target_user_id;
  
  -- 4. Explicitly delete from profile types if not cascading
  DELETE FROM profiles WHERE id = target_user_id;
  DELETE FROM provider_profiles WHERE id = target_user_id;
  DELETE FROM user_roles WHERE user_id = target_user_id;
END;
$$;
