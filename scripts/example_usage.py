#!/usr/bin/env python3
"""
Example usage of the June Waitlist Pusher
"""

import os
from push_waitlist_data import JuneWaitlistPusher, WaitlistEntry

# Your Supabase credentials (replace with your actual values)
SUPABASE_URL = "https://your-project-id.supabase.co"
SUPABASE_KEY = "your-anon-key"

def main():
    """Example usage of the waitlist pusher"""
    
    # Initialize the pusher
    pusher = JuneWaitlistPusher(SUPABASE_URL, SUPABASE_KEY)
    
    # Example 1: Push a single entry
    print("=== Example 1: Single Entry ===")
    entry = WaitlistEntry(
        email="john.doe@example.com",
        name="John Doe",
        phone="+15551234567",
        gender="Male",
        age=28,
        instagram="@johndoe",
        linkedin="linkedin.com/in/john-doe",
        twitter="@johndoe",
        batch_number=1
    )
    
    result = pusher.push_single_entry(entry)
    print(f"Result: {result}")
    
    # Example 2: Generate and push sample data
    print("\n=== Example 2: Sample Data ===")
    sample_entries = pusher.generate_sample_data(count=5)
    results = pusher.push_multiple_entries(sample_entries)
    
    # Example 3: Get current count
    print("\n=== Example 3: Current Count ===")
    count = pusher.get_waitlist_count()
    print(f"Current waitlist count: {count}")
    
    # Example 4: Push from JSON file
    print("\n=== Example 4: From JSON File ===")
    json_file = "sample_waitlist_data.json"
    if os.path.exists(json_file):
        results = pusher.push_from_json(json_file)
    else:
        print(f"JSON file {json_file} not found")

if __name__ == "__main__":
    # Check if credentials are set
    if SUPABASE_URL == "https://your-project-id.supabase.co":
        print("❌ Please update SUPABASE_URL and SUPABASE_KEY with your actual credentials")
        print("You can find these in your Supabase project settings")
    else:
        main()
