-- Access Code Management for June Waitlist
-- Run these in your Supabase SQL Editor

-- ========================================
-- 1. CREATE ACCESS CODE GENERATION FUNCTION
-- ========================================
-- This function generates 6-character codes matching your existing format
CREATE OR REPLACE FUNCTION generate_access_code()
RETURNS TEXT AS $$
DECLARE
  chars TEXT := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  result TEXT := '';
  i INT;
  max_attempts INT := 10;
  attempt INT := 0;
BEGIN
  LOOP
    result := '';
    FOR i IN 1..6 LOOP
      result := result || SUBSTRING(chars, (floor(random() * LENGTH(chars)) + 1)::int, 1);
    END LOOP;
    
    -- Check if code already exists
    IF NOT EXISTS (SELECT 1 FROM waitlist WHERE access_code = result) THEN
      RETURN result;
    END IF;
    
    attempt := attempt + 1;
    IF attempt >= max_attempts THEN
      -- No timestamp-based fallback; enforce strict uniqueness policy
      RAISE EXCEPTION 'Failed to generate unique access code after % attempts', max_attempts;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql VOLATILE;

-- ========================================
-- 2. FUNCTION TO CREATE ACCESS CODES FOR EXISTING ENTRIES
-- ========================================
-- This function assigns access codes to entries that don't have one
-- and returns the rows that were updated
CREATE OR REPLACE FUNCTION assign_missing_access_codes()
RETURNS TABLE (
  id BIGINT,
  access_code TEXT,
  name TEXT,
  created_at TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  WITH updated_rows AS (
    UPDATE waitlist AS w
    SET access_code = generate_access_code()
    WHERE w.access_code IS NULL OR w.access_code = ''
    RETURNING w.id       AS r_id,
              w.access_code AS r_access_code,
              w.name     AS r_name,
              w.created_at AS r_created_at
  )
  SELECT r_id AS id,
         r_access_code AS access_code,
         r_name AS name,
         r_created_at AS created_at
  FROM updated_rows;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- 3. TRIGGER FUNCTION FOR AUTOMATIC ACCESS CODE CREATION
-- ========================================
-- This ensures every new entry gets an access code automatically
CREATE OR REPLACE FUNCTION trigger_waitlist_access_code()
RETURNS TRIGGER AS $$
BEGIN
  -- Only set access_code if it's NULL or empty
  IF NEW.access_code IS NULL OR NEW.access_code = '' THEN
    NEW.access_code := generate_access_code();
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- 4. CREATE TRIGGER FOR NEW ENTRIES
-- ========================================
-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS waitlist_access_code_trigger ON waitlist;

-- Create the trigger
CREATE TRIGGER waitlist_access_code_trigger
  BEFORE INSERT ON waitlist
  FOR EACH ROW
  EXECUTE FUNCTION trigger_waitlist_access_code();

-- Ensure access_code remains unique (idempotent)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'unique_access_code' AND conrelid = 'waitlist'::regclass
  ) THEN
    ALTER TABLE waitlist ADD CONSTRAINT unique_access_code UNIQUE (access_code);
  END IF;
END $$;

-- ========================================
-- 5. EXECUTION COMMANDS
-- ========================================

-- First, run this to assign codes to existing entries without one:
-- SELECT * FROM assign_missing_access_codes();

-- Then check how many entries now have access codes:
-- SELECT 
--   COUNT(*) as total_entries,
--   COUNT(access_code) as entries_with_codes,
--   COUNT(*) - COUNT(access_code) as entries_without_codes
-- FROM waitlist;

-- ========================================
-- 6. VERIFICATION QUERIES
-- ========================================

-- Test the access code generation function:
-- SELECT generate_access_code() as test_code_1,
--        generate_access_code() as test_code_2,
--        generate_access_code() as test_code_3;

-- Check for any duplicate access codes:
-- SELECT access_code, COUNT(*) as count
-- FROM waitlist 
-- WHERE access_code IS NOT NULL
-- GROUP BY access_code
-- HAVING COUNT(*) > 1;

-- View all entries with their access codes:
-- SELECT id, name, access_code, created_at
-- FROM waitlist
-- ORDER BY created_at DESC
-- LIMIT 10;
