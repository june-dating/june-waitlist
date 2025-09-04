import type { Metadata } from "next"

export const metadata: Metadata = {
  title: "Privacy Policy",
  description:
    "June's privacy policy. Learn how we protect your data and use it only to find your perfect match.",
  keywords: [
    "june privacy policy",
    "dating app privacy", 
    "data protection",
    "user privacy",
    "june data collection",
    "privacy rights",
    "data security"
  ],
  authors: [{ name: "June Team" }],
  creator: "June",
  publisher: "June",
  openGraph: {
    type: "article",
    url: "https://june.date/privacy",
    title: "June Privacy Policy",
    description:
      "Learn how we protect your data and use it only to find your perfect match.",
    images: [
      {
        url: "https://june.date/images/june-social.png",
        width: 1200,
        height: 630,
        alt: "June Privacy Policy",
        type: "image/png",
      }
    ],
    siteName: "June",
    locale: "en_US",
  },
  twitter: {
    card: "summary_large_image",
    site: "@junedate",
    creator: "@junedate",
    title: "June Privacy Policy",
    description:
      "Learn how we protect your data and use it only to find your perfect match.",
    images: ["https://june.date/images/june-social.png"],
  },
  alternates: {
    canonical: "https://june.date/privacy",
  },
  robots: {
    index: true,
    follow: true,
  },
}

export default function Privacy() {
  return (
    <div className="max-w-4xl mx-auto p-6 space-y-8">
        <div className="text-center space-y-4 mb-12">
          <h1 className="text-4xl font-bold text-black">Privacy Policy</h1>
          <p className="text-xl text-black">
            Last Modified: August 18, 2025
          </p>
        </div>

        <div className="space-y-8 text-black">
          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Introduction</h2>
            <p className="leading-relaxed">
              Welcome to June, the AI-powered dating app that's revolutionizing how people find meaningful connections. 
              At June, we believe your privacy is fundamental. This Privacy Policy explains how we collect, use, and 
              protect your information with one simple principle: your data is used solely to help you find your perfect match.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Our Core Privacy Promise</h2>
            <div className="bg-white/20 p-6 rounded-lg border border-gray-300">
              <p className="text-lg font-medium text-black mb-2">
                We only collect and use your data for one purpose: finding you the right match.
              </p>
              <p className="leading-relaxed">
                Unlike other dating platforms, we don't sell your data to third parties, use it for advertising to external companies, 
                or repurpose it for unrelated business ventures. Every piece of information we collect serves one goal: 
                connecting you with someone special.
              </p>
            </div>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Information We Collect</h2>
            <div className="space-y-4">
              <div>
                <h3 className="text-xl font-medium text-black mb-2">Profile Information</h3>
                <ul className="list-disc pl-6 space-y-1">
                  <li>Basic details (name, age, location)</li>
                  <li>Photos and profile descriptions</li>
                  <li>Preferences and interests</li>
                  <li>Relationship goals and values</li>
                </ul>
              </div>
              <div>
                <h3 className="text-xl font-medium text-black mb-2">App Usage Data</h3>
                <ul className="list-disc pl-6 space-y-1">
                  <li>How you interact with potential matches</li>
                  <li>Communication patterns and preferences</li>
                  <li>Feature usage to improve our matching algorithm</li>
                </ul>
              </div>
            </div>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">How We Use Your Information</h2>
            <div className="space-y-4">
              <div>
                <h3 className="text-xl font-medium text-black mb-2">Matchmaking Excellence</h3>
                <p className="leading-relaxed">
                  Our AI analyzes your profile, preferences, and behavior to understand what makes you unique and 
                  what you're looking for in a partner. This allows us to suggest highly compatible matches instead 
                  of requiring endless swiping.
                </p>
              </div>
              <div>
                <h3 className="text-xl font-medium text-black mb-2">Safety and Security</h3>
                <p className="leading-relaxed">
                  We use your information to verify profiles, prevent fraud, and maintain a safe dating environment 
                  for all our users.
                </p>
              </div>
              <div>
                <h3 className="text-xl font-medium text-black mb-2">Service Improvement</h3>
                <p className="leading-relaxed">
                  We analyze usage patterns to improve our matching algorithms and user experience, always with 
                  the goal of helping you find better connections.
                </p>
              </div>
            </div>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Your Rights and Control</h2>
            <div className="space-y-4">
              <p className="leading-relaxed">You have complete control over your data:</p>
              <ul className="list-disc pl-6 space-y-1">
                <li>Access and review your information at any time</li>
                <li>Update or correct your profile details</li>
                <li>Delete your account and all associated data</li>
                <li>Export your data in a portable format</li>
                <li>Opt out of certain data processing activities</li>
              </ul>
            </div>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Data Security</h2>
            <p className="leading-relaxed">
              We implement industry-standard security measures to protect your information, including encryption, 
              secure servers, and regular security audits. Your trust is paramount to us.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Updates to This Policy</h2>
            <p className="leading-relaxed">
              We may update this Privacy Policy from time to time. We'll notify you of any material changes 
              through the app or via SMS.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Contact Us</h2>
            <div className="bg-white/20 p-6 rounded-lg border border-gray-300">
              <p className="leading-relaxed mb-4">
                Have questions about your privacy or how we handle your data? We're here to help.
              </p>
              <p className="text-lg">
                <strong className="text-black">Email:</strong> 
                <a href="mailto:hello@june.date" className="text-black ml-2">
                  hello@june.date
                </a>
              </p>
              <p className="mt-2 text-sm text-gray-600">
                We typically respond within 24 hours
              </p>
            </div>
          </section>
        </div>
    </div>
  )
}