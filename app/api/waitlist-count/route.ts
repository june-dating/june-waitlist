import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/client";

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

export async function GET() {
  try {
    const supabase = createClient();

    const { count, error } = await supabase
      .from("waitlist")
      .select("*", { count: "exact", head: true });

    if (error) {
      console.error("Error fetching waitlist count:", error);
      return NextResponse.json(
        { error: "Failed to fetch waitlist count" },
        { status: 500 }
      );
    }

    return NextResponse.json({
      count: count || 0,
      success: true,
    });
  } catch (error) {
    console.error("Error fetching waitlist count:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
