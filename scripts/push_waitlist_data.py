#!/usr/bin/env python3
"""
June Waitlist Data Pusher
Push data into the Supabase waitlist table
"""

import os
import sys
import json
import random
import string
from datetime import datetime, timezone
from typing import List, Dict, Optional
import requests
from dataclasses import dataclass
import argparse

# Add project root to path for imports
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

@dataclass
class WaitlistEntry:
    """Data class for waitlist entries"""
    email: str
    name: str
    phone: str
    gender: str  # 'Male', 'Female', 'Other'
    age: int  # 18-99
    instagram: str
    linkedin: Optional[str] = None
    twitter: Optional[str] = None
    batch_number: Optional[int] = None

class JuneWaitlistPusher:
    """Main class for pushing data to June waitlist"""
    
    def __init__(self, supabase_url: str, supabase_key: str):
        """
        Initialize the pusher with Supabase credentials
        
        Args:
            supabase_url: Your Supabase project URL
            supabase_key: Your Supabase anon key
        """
        self.supabase_url = supabase_url.rstrip('/')
        self.supabase_key = supabase_key
        self.headers = {
            'apikey': supabase_key,
            'Authorization': f'Bearer {supabase_key}',
            'Content-Type': 'application/json',
            'Prefer': 'return=minimal'
        }
    
    def push_single_entry(self, entry: WaitlistEntry) -> Dict:
        """
        Push a single waitlist entry to the database
        
        Args:
            entry: WaitlistEntry object with user data
            
        Returns:
            Dict with response data
        """
        # Prepare data for Supabase
        data = {
            'email': entry.email,
            'name': entry.name,
            'phone': entry.phone,
            'gender': entry.gender,
            'age': entry.age,
            'instagram': entry.instagram,
            'linkedin': entry.linkedin,
            'twitter': entry.twitter,
            'batch_number': entry.batch_number
        }
        
        # Remove None values
        data = {k: v for k, v in data.items() if v is not None}
        
        url = f"{self.supabase_url}/rest/v1/waitlist"
        
        try:
            response = requests.post(url, headers=self.headers, json=data)
            response.raise_for_status()
            
            print(f"✅ Successfully added: {entry.name} ({entry.email})")
            return {
                'success': True,
                'data': data,
                'status_code': response.status_code
            }
            
        except requests.exceptions.RequestException as e:
            error_msg = f"❌ Failed to add {entry.name} ({entry.email}): {str(e)}"
            print(error_msg)
            return {
                'success': False,
                'error': str(e),
                'data': data
            }
    
    def push_multiple_entries(self, entries: List[WaitlistEntry]) -> List[Dict]:
        """
        Push multiple waitlist entries to the database
        
        Args:
            entries: List of WaitlistEntry objects
            
        Returns:
            List of response dictionaries
        """
        results = []
        
        for i, entry in enumerate(entries, 1):
            print(f"Processing entry {i}/{len(entries)}...")
            result = self.push_single_entry(entry)
            results.append(result)
            
            # Small delay to avoid rate limiting
            import time
            time.sleep(0.1)
        
        # Summary
        successful = sum(1 for r in results if r['success'])
        failed = len(results) - successful
        
        print(f"\n📊 Summary: {successful} successful, {failed} failed")
        return results
    
    def generate_sample_data(self, count: int = 10) -> List[WaitlistEntry]:
        """
        Generate sample waitlist data for testing
        
        Args:
            count: Number of sample entries to generate
            
        Returns:
            List of WaitlistEntry objects
        """
        # Sample data pools
        first_names = [
            "Alex", "Jordan", "Taylor", "Casey", "Morgan", "Riley", "Avery", "Quinn",
            "Blake", "Cameron", "Drew", "Emery", "Finley", "Hayden", "Jamie", "Kendall",
            "Logan", "Peyton", "Reese", "Sage", "Skyler", "Sydney", "Tatum", "River"
        ]
        
        last_names = [
            "Anderson", "Brown", "Davis", "Garcia", "Johnson", "Jones", "Miller",
            "Rodriguez", "Smith", "Taylor", "Thomas", "Wilson", "Moore", "Jackson",
            "Martin", "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark"
        ]
        
        genders = ["Male", "Female", "Other"]
        domains = ["gmail.com", "yahoo.com", "hotmail.com", "outlook.com", "icloud.com"]
        
        entries = []
        
        for i in range(count):
            first_name = random.choice(first_names)
            last_name = random.choice(last_names)
            
            entry = WaitlistEntry(
                email=f"{first_name.lower()}.{last_name.lower()}{i}@{random.choice(domains)}",
                name=f"{first_name} {last_name}",
                phone=self._generate_phone(),
                gender=random.choice(genders),
                age=random.randint(18, 35),
                instagram=f"@{first_name.lower()}{last_name.lower()}",
                linkedin=f"linkedin.com/in/{first_name.lower()}-{last_name.lower()}" if random.random() > 0.3 else None,
                twitter=f"@{first_name.lower()}{last_name.lower()}" if random.random() > 0.5 else None,
                batch_number=random.randint(1, 5)
            )
            entries.append(entry)
        
        return entries
    
    def _generate_phone(self) -> str:
        """Generate a random US phone number"""
        area_code = random.randint(200, 999)
        exchange = random.randint(200, 999)
        number = random.randint(1000, 9999)
        return f"+1{area_code}{exchange}{number}"
    
    def push_from_json(self, json_file: str) -> List[Dict]:
        """
        Push data from a JSON file
        
        Args:
            json_file: Path to JSON file with waitlist data
            
        Returns:
            List of response dictionaries
        """
        try:
            with open(json_file, 'r') as f:
                data = json.load(f)
            
            entries = []
            for item in data:
                entry = WaitlistEntry(**item)
                entries.append(entry)
            
            return self.push_multiple_entries(entries)
            
        except FileNotFoundError:
            print(f"❌ File not found: {json_file}")
            return []
        except json.JSONDecodeError as e:
            print(f"❌ Invalid JSON: {e}")
            return []
        except Exception as e:
            print(f"❌ Error reading file: {e}")
            return []
    
    def get_waitlist_count(self) -> int:
        """
        Get the current count of waitlist entries
        
        Returns:
            Number of entries in the waitlist
        """
        url = f"{self.supabase_url}/rest/v1/waitlist?select=count"
        headers = {
            'apikey': self.supabase_key,
            'Authorization': f'Bearer {self.supabase_key}',
            'Prefer': 'count=exact'
        }
        
        try:
            response = requests.get(url, headers=headers)
            response.raise_for_status()
            
            # Get count from response headers
            count = response.headers.get('content-range', '0')
            if '/' in count:
                count = count.split('/')[-1]
            
            return int(count)
            
        except Exception as e:
            print(f"❌ Error getting count: {e}")
            return 0

def main():
    """Main function for command line usage"""
    parser = argparse.ArgumentParser(description='Push data to June waitlist')
    parser.add_argument('--url', required=True, help='Supabase URL')
    parser.add_argument('--key', required=True, help='Supabase anon key')
    parser.add_argument('--count', type=int, default=10, help='Number of sample entries to generate')
    parser.add_argument('--json', help='Path to JSON file with waitlist data')
    parser.add_argument('--count-only', action='store_true', help='Just show current count')
    
    args = parser.parse_args()
    
    # Initialize pusher
    pusher = JuneWaitlistPusher(args.url, args.key)
    
    if args.count_only:
        count = pusher.get_waitlist_count()
        print(f"📊 Current waitlist count: {count}")
        return
    
    if args.json:
        print(f"📁 Loading data from {args.json}...")
        results = pusher.push_from_json(args.json)
    else:
        print(f"🎲 Generating {args.count} sample entries...")
        entries = pusher.generate_sample_data(args.count)
        results = pusher.push_multiple_entries(entries)
    
    # Show final count
    final_count = pusher.get_waitlist_count()
    print(f"📊 Final waitlist count: {final_count}")

if __name__ == "__main__":
    main()
