import { createClient } from "@/lib/supabase/client";
import { NextRequest, NextResponse } from "next/server";

// CORS headers - allow all origins
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

// Handle OPTIONS preflight request
export async function OPTIONS() {
  return NextResponse.json({}, { headers: corsHeaders });
}

const formatSocialUrl = (value: string) => {
  try {
    if (!value) return { instagram: null, linkedin: null, twitter: null };

    // If already a full URL, determine the platform
    if (value.startsWith("http://") || value.startsWith("https://")) {
      if (value.includes("instagram.com")) {
        return { instagram: value, linkedin: null, twitter: null };
      } else if (value.includes("linkedin.com")) {
        return { instagram: null, linkedin: value, twitter: null };
      } else if (value.includes("twitter.com") || value.includes("x.com")) {
        return { instagram: null, linkedin: null, twitter: value };
      }
      // Default to Instagram if unknown URL
      return { instagram: value, linkedin: null, twitter: null };
    }

    // Remove @ if present at the start
    const cleanValue = value.startsWith("@") ? value.slice(1) : value;

    // Default to Instagram for username-only entries
    return {
      instagram: `https://instagram.com/${cleanValue}`,
      linkedin: null,
      twitter: null,
    };
  } catch (err: any) {
    console.error("Error formatting social URL:", value, err.message);
    return {
      instagram: null,
      linkedin: null,
      twitter: null,
    };
  }
};

export async function POST(request: NextRequest) {
  try {
    const payload = await request.json();
    console.log("Payload received:", payload);

    // Validate required fields
    const requiredFields = [
      "name",
      "phone",
      "location",
      "age",
      "social",
    ];
    for (const field of requiredFields) {
      if (!payload[field]) {
        console.error(`Missing required field: ${field}`);
        return NextResponse.json(
          { error: `Missing required field: ${field}` },
          { status: 400, headers: corsHeaders }
        );
      }
    }

    // Format social URLs
    const socialUrls = formatSocialUrl(payload.social);

    // Create row object for waitlist table
    const row = {
      email: payload.email || null,
      name: payload.name,
      phone: `${payload.phone}`,
      location: payload.location,
      gender: null, 
      age: parseInt(payload.age),
      ...socialUrls,
      utm_source: payload.utm_source,
      utm_medium: payload.utm_medium,
      utm_campaign: payload.utm_campaign,
    };

    // Insert into Supabase
    const supabase = createClient();
    const { data, error } = await supabase
      .from("waitlist")
      .insert([row])
      .select();

    if (error) {
      console.error("Supabase error:", error);
      return NextResponse.json(
        { error: "Failed to join waitlist" },
        { status: 500, headers: corsHeaders }
      );
    }

    return NextResponse.json({ success: true, data }, { status: 201, headers: corsHeaders });
  } catch (error) {
    console.error("API error:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500, headers: corsHeaders }
    );
  }
}
