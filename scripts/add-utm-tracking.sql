-- Add UTM tracking columns to the waitlist table
-- Run this in your Supabase SQL Editor

ALTER TABLE waitlist 
ADD COLUMN IF NOT EXISTS utm_source TEXT,
ADD COLUMN IF NOT EXISTS utm_medium TEXT,
ADD COLUMN IF NOT EXISTS utm_campaign TEXT;

-- Add indexes for analytics queries
CREATE INDEX IF NOT EXISTS idx_waitlist_utm_source ON waitlist(utm_source);
CREATE INDEX IF NOT EXISTS idx_waitlist_utm_medium ON waitlist(utm_medium);
CREATE INDEX IF NOT EXISTS idx_waitlist_utm_campaign ON waitlist(utm_campaign);
