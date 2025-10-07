-- Complete Waitlist Table Setup for June Premium Application
-- Run this entire script in your Supabase SQL Editor

-- ========================================
-- 1. CREATE THE WAITLIST TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS waitlist (
  id BIGSERIAL PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  gender TEXT NOT NULL CHECK (gender IN ('Male', 'Female', 'Other')),
  age INTEGER NOT NULL CHECK (age >= 18 AND age <= 99),
  instagram TEXT NOT NULL,
  linkedin TEXT,
  twitter TEXT,
  location TEXT,
  priority_score INTEGER DEFAULT 0,
  access_code TEXT UNIQUE,
  batch_number INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- 2. CREATE INDEXES FOR PERFORMANCE
-- ========================================
CREATE INDEX IF NOT EXISTS idx_waitlist_email ON waitlist(email);
CREATE INDEX IF NOT EXISTS idx_waitlist_created_at ON waitlist(created_at);
CREATE INDEX IF NOT EXISTS idx_waitlist_batch_number ON waitlist(batch_number);
CREATE INDEX IF NOT EXISTS idx_waitlist_priority_score ON waitlist(priority_score DESC);
CREATE INDEX IF NOT EXISTS idx_waitlist_access_code ON waitlist(access_code);
CREATE INDEX IF NOT EXISTS idx_waitlist_location ON waitlist(location);
CREATE INDEX IF NOT EXISTS idx_waitlist_name ON waitlist(name);
CREATE INDEX IF NOT EXISTS idx_waitlist_phone ON waitlist(phone);
CREATE INDEX IF NOT EXISTS idx_waitlist_gender ON waitlist(gender);
CREATE INDEX IF NOT EXISTS idx_waitlist_age ON waitlist(age);
CREATE INDEX IF NOT EXISTS idx_waitlist_instagram ON waitlist(instagram);
CREATE INDEX IF NOT EXISTS idx_waitlist_updated_at ON waitlist(updated_at);

-- ========================================
-- 3. ENABLE ROW LEVEL SECURITY
-- ========================================
ALTER TABLE waitlist ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 4. CREATE RLS POLICIES
-- ========================================
-- Allow anonymous users to insert data (for waitlist form)
CREATE POLICY "Enable insert for anonymous users" ON waitlist
  FOR INSERT 
  TO anon 
  WITH CHECK (true);

-- Allow public to read data (for analytics)
CREATE POLICY "Enable select for users based on email" ON waitlist
  FOR SELECT 
  TO anon, authenticated
  USING (true);

-- Allow authenticated users (admins) to read all data
CREATE POLICY "Enable full access for authenticated users" ON waitlist
  FOR ALL 
  TO authenticated 
  USING (true)
  WITH CHECK (true);

-- ========================================
-- 5. GRANT PERMISSIONS
-- ========================================
-- Grant necessary permissions to anon role
GRANT INSERT ON waitlist TO anon;
GRANT SELECT ON waitlist TO anon;

-- Grant full permissions to authenticated role
GRANT ALL ON waitlist TO authenticated;

-- Grant usage on the sequence for the id column
GRANT USAGE ON SEQUENCE waitlist_id_seq TO anon;
GRANT USAGE ON SEQUENCE waitlist_id_seq TO authenticated;

-- ========================================
-- 6. ENHANCED ACCESS CODE GENERATION
-- ========================================
-- Function to generate 6-digit alternating number-letter access codes
CREATE OR REPLACE FUNCTION generate_access_code() RETURNS TEXT AS $$
DECLARE
  code TEXT := '';
  numbers TEXT := '0123456789';
  letters TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  i INTEGER;
BEGIN
  -- Generate 6-character alternating number-letter code
  FOR i IN 1..6 LOOP
    IF i % 2 = 1 THEN
      -- Odd positions: numbers (1st, 3rd, 5th)
      code := code || SUBSTRING(numbers, (RANDOM() * 9)::INTEGER + 1, 1);
    ELSE
      -- Even positions: letters (2nd, 4th, 6th)
      code := code || SUBSTRING(letters, (RANDOM() * 25)::INTEGER + 1, 1);
    END IF;
  END LOOP;
  
  RETURN code;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- 7. ENHANCED PRIORITY SCORING SYSTEM
-- ========================================
-- Enhanced function to calculate priority score with comprehensive scoring system
CREATE OR REPLACE FUNCTION calculate_priority_score(
  p_name TEXT,
  p_phone TEXT,
  p_location TEXT,
  p_gender TEXT,
  p_age INTEGER,
  p_instagram TEXT,
  p_linkedin TEXT,
  p_twitter TEXT
) RETURNS INTEGER AS $$
DECLARE
  score INTEGER := 0;
  field_count INTEGER := 0;
BEGIN
  -- Base score for starting application
  score := 50;
  
  -- Count and score for filled required fields
  IF p_name IS NOT NULL AND LENGTH(TRIM(p_name)) > 0 THEN
    field_count := field_count + 1;
    score := score + 15; -- Required field bonus
  END IF;
  
  IF p_phone IS NOT NULL AND LENGTH(TRIM(p_phone)) > 0 THEN
    field_count := field_count + 1;
    score := score + 15; -- Required field bonus
  END IF;
  
  IF p_location IS NOT NULL AND LENGTH(TRIM(p_location)) > 0 THEN
    field_count := field_count + 1;
    score := score + 15; -- Required field bonus
  END IF;
  
  IF p_gender IS NOT NULL AND LENGTH(TRIM(p_gender)) > 0 THEN
    field_count := field_count + 1;
    score := score + 10; -- Required field bonus
  END IF;
  
  IF p_age IS NOT NULL AND p_age BETWEEN 18 AND 99 THEN
    field_count := field_count + 1;
    score := score + 10; -- Required field bonus
  END IF;
  
  -- Social media profile bonuses (higher priority on Instagram)
  IF p_instagram IS NOT NULL AND LENGTH(TRIM(p_instagram)) > 1 THEN
    field_count := field_count + 1;
    score := score + 40; -- Instagram is most important for dating app
  END IF;
  
  IF p_linkedin IS NOT NULL AND LENGTH(TRIM(p_linkedin)) > 1 THEN
    field_count := field_count + 1;
    score := score + 25; -- LinkedIn shows professional presence
  END IF;
  
  IF p_twitter IS NOT NULL AND LENGTH(TRIM(p_twitter)) > 1 THEN
    field_count := field_count + 1;
    score := score + 15; -- Twitter shows social engagement
  END IF;
  
  -- Completion bonus for having all fields filled
  IF field_count >= 7 THEN -- All required fields + at least 2 social
    score := score + 30;
  ELSIF field_count >= 6 THEN -- Most fields filled
    score := score + 20;
  ELSIF field_count >= 5 THEN -- Basic completion
    score := score + 10;
  END IF;
  
  -- Location-based bonus (New York gets priority)
  IF p_location IS NOT NULL THEN
    -- Check for New York variations (case insensitive)
    IF LOWER(p_location) LIKE '%new york%' OR 
       LOWER(p_location) LIKE '%nyc%' OR 
       LOWER(p_location) LIKE '%manhattan%' OR 
       LOWER(p_location) LIKE '%brooklyn%' OR 
       LOWER(p_location) LIKE '%queens%' OR 
       LOWER(p_location) LIKE '%bronx%' OR 
       LOWER(p_location) LIKE '%staten island%' THEN
      score := score + 100; -- Big bonus for New York area
    END IF;
  END IF;
  
  -- Gender-based bonus
  IF p_gender IS NOT NULL AND LOWER(TRIM(p_gender)) = 'female' THEN
    score := score + 10; -- Bonus for female users
  END IF;
  
  -- Age-based scoring (dating apps favor certain age ranges)
  IF p_age IS NOT NULL THEN
    IF p_age BETWEEN 22 AND 32 THEN
      score := score + 15; -- Prime dating age gets bonus
    ELSIF p_age BETWEEN 18 AND 35 THEN
      score := score + 10; -- Still in high-activity range
    ELSIF p_age BETWEEN 36 AND 45 THEN
      score := score + 5; -- Moderate bonus
    END IF;
  END IF;
  
  -- Ensure minimum score
  IF score < 50 THEN
    score := 50;
  END IF;
  
  RETURN score;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- 8. ENHANCED TRIGGER FUNCTION
-- ========================================
-- Enhanced trigger function with improved validation and scoring
CREATE OR REPLACE FUNCTION trigger_waitlist_insert() RETURNS TRIGGER AS $$
DECLARE
  generated_code TEXT;
  max_attempts INTEGER := 10;
  attempt INTEGER := 0;
BEGIN
  -- Generate unique access code with retry logic
  LOOP
    generated_code := generate_access_code();
    
    -- Check if code already exists
    IF NOT EXISTS (SELECT 1 FROM waitlist WHERE access_code = generated_code) THEN
      NEW.access_code := generated_code;
      EXIT;
    END IF;
    
    attempt := attempt + 1;
    IF attempt >= max_attempts THEN
      -- Fallback to timestamp-based code if we can't generate unique code
      NEW.access_code := SUBSTRING(UPPER(MD5(EXTRACT(EPOCH FROM NOW())::TEXT)), 1, 6);
      EXIT;
    END IF;
  END LOOP;
  
  -- Calculate priority score with all available data
  NEW.priority_score := calculate_priority_score(
    NEW.name,
    NEW.phone,
    NEW.location,
    NEW.gender,
    NEW.age,
    NEW.instagram,
    NEW.linkedin,
    NEW.twitter
  );
  
  -- Update timestamp
  NEW.updated_at := NOW();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- 9. CREATE TRIGGER
-- ========================================
-- Drop and recreate the trigger to use the new function
DROP TRIGGER IF EXISTS waitlist_insert_trigger ON waitlist;
CREATE TRIGGER waitlist_insert_trigger
  BEFORE INSERT OR UPDATE ON waitlist
  FOR EACH ROW
  EXECUTE FUNCTION trigger_waitlist_insert();

-- ========================================
-- 10. ANALYTICS VIEW
-- ========================================
-- Create a view for easy access to waitlist statistics
CREATE OR REPLACE VIEW waitlist_stats AS
SELECT 
  COUNT(*) as total_applications,
  COUNT(CASE WHEN instagram IS NOT NULL AND LENGTH(TRIM(instagram)) > 1 THEN 1 END) as with_instagram,
  COUNT(CASE WHEN linkedin IS NOT NULL AND LENGTH(TRIM(linkedin)) > 1 THEN 1 END) as with_linkedin,
  COUNT(CASE WHEN twitter IS NOT NULL AND LENGTH(TRIM(twitter)) > 1 THEN 1 END) as with_twitter,
  COUNT(CASE WHEN gender = 'Female' THEN 1 END) as female_users,
  COUNT(CASE WHEN gender = 'Male' THEN 1 END) as male_users,
  COUNT(CASE WHEN gender = 'Other' THEN 1 END) as other_gender,
  COUNT(CASE WHEN LOWER(location) LIKE '%new york%' THEN 1 END) as new_york_users,
  AVG(priority_score)::DECIMAL(10,2) as avg_priority_score,
  MAX(priority_score) as max_priority_score,
  MIN(priority_score) as min_priority_score
FROM waitlist;

-- ========================================
-- 11. VERIFICATION QUERIES
-- ========================================
-- Check table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'waitlist' 
ORDER BY ordinal_position;

-- Check if RLS is enabled
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'waitlist';

-- Check existing RLS policies
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'waitlist';

-- Test access code generation
SELECT generate_access_code() as test_code_1,
       generate_access_code() as test_code_2,
       generate_access_code() as test_code_3;

-- Test priority score calculation
SELECT calculate_priority_score(
  'John Doe',                    -- name
  '+1234567890',                 -- phone
  'New York, NY',                -- location
  'Male',                        -- gender
  28,                            -- age
  'https://instagram.com/john',   -- instagram
  'https://linkedin.com/in/john', -- linkedin
  'https://twitter.com/john'      -- twitter
) as test_score;

-- ========================================
-- SETUP COMPLETE! 🎉
-- ========================================
-- Your waitlist table is now ready with:
-- ✅ Enhanced priority scoring system
-- ✅ 6-digit alternating access codes
-- ✅ Row Level Security policies
-- ✅ Performance indexes
-- ✅ Analytics view
-- ✅ Automatic triggers

-- Next steps:
-- 1. Update your .env.local with new Supabase credentials
-- 2. Test the waitlist form
-- 3. Check the waitlist_stats view for analytics
