-- This script is designed to update the Supabase schema.
-- WARNING: This will delete data. Always backup your data before running scripts.

-- Step 1: Drop the now-unused 'members' table.
-- This table was part of the old authentication system which has been removed.
DROP TABLE IF EXISTS public.members;

-- Step 2: Clear the 'ficha_tecnica' column in the 'agents' table.
-- This prepares the table for the new, more complex Ficha Técnica structure.
-- It sets the value to NULL for all existing agents.
UPDATE public.agents
SET ficha_tecnica = NULL;

-- Optional: If you want to completely reset the table to an empty JSON object {}
-- instead of NULL, you can use the following command instead.
-- UPDATE public.agents
-- SET ficha_tecnica = '{}'::jsonb;

-- End of script.
