import type { Metadata } from "next"

export const metadata: Metadata = {
  title: "Terms of Service",
  description:
    "June's terms of service. Understand our commitment to helping you find meaningful connections.",
  keywords: [
    "june terms of service",
    "dating app terms", 
    "user agreement",
    "june conditions",
    "dating app rules",
    "service terms",
    "user responsibilities"
  ],
  authors: [{ name: "June Team" }],
  creator: "June",
  publisher: "June",
  openGraph: {
    type: "article",
    url: "https://june.date/terms",
    title: "June Terms of Service",
    description:
      "Understand our commitment to helping you find meaningful connections.",
    images: [
      {
        url: "https://june.date/images/june-social.png",
        width: 1200,
        height: 630,
        alt: "June Terms of Service",
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
    title: "June Terms of Service",
    description:
      "Understand our commitment to helping you find meaningful connections.",
    images: ["https://june.date/images/june-social.png"],
  },
  alternates: {
    canonical: "https://june.date/terms",
  },
  robots: {
    index: true,
    follow: true,
  },
}

export default function Terms() {
  return (
    <div className="max-w-4xl mx-auto p-6 space-y-8">
        <div className="text-center space-y-4 mb-12">
          <h1 className="text-4xl font-bold text-black">Terms of Service</h1>
          <p className="text-xl text-black">
            Last Modified: August 18, 2025
          </p>
        </div>

        <div className="space-y-8 text-black">
          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Welcome to June</h2>
            <p className="leading-relaxed">
              By using June, you agree to these Terms of Service. June is an AI-powered dating platform designed 
              to help you find meaningful connections. Our mission is simple: use technology to help you find 
              your perfect match without the frustration of endless swiping.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Our Service Commitment</h2>
            <div className="bg-white/20 p-6 rounded-lg border border-gray-300">
              <p className="text-lg font-medium text-black mb-2">
                June exists for one purpose: helping you find the right match.
              </p>
              <p className="leading-relaxed">
                All data we collect and every feature we build serves this single goal. We're not in the business 
                of keeping you on the app forever—we want to help you find someone special and build a meaningful 
                relationship in the real world.
              </p>
            </div>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">User Responsibilities</h2>
            <div className="space-y-4">
              <h3 className="text-xl font-medium text-black">Profile Authenticity</h3>
              <p className="leading-relaxed mb-4">
                You agree to provide accurate, current, and complete information about yourself. This includes:
              </p>
              <ul className="list-disc pl-6 space-y-1">
                <li>Using recent, unfiltered photos of yourself</li>
                <li>Providing truthful personal information</li>
                <li>Not impersonating others</li>
                <li>Not creating multiple accounts</li>
              </ul>
            </div>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Community Guidelines</h2>
            <p className="leading-relaxed mb-4">
              June is built on respect, authenticity, and genuine connection. We expect all users to:
            </p>
            <ul className="list-disc pl-6 space-y-1">
              <li>Treat others with respect and kindness</li>
              <li>Communicate honestly and authentically</li>
              <li>Respect boundaries and consent</li>
              <li>Report inappropriate behavior</li>
              <li>Not use the platform for commercial purposes</li>
            </ul>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Privacy and Data Use</h2>
            <p className="leading-relaxed">
              Your privacy is fundamental to our service. We collect and use your information exclusively to help 
              you find compatible matches. For detailed information about how we handle your data, please read our{" "}
              <a href="/privacy" className="text-black">Privacy Policy</a>.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Account Termination</h2>
            <p className="leading-relaxed">
              You may delete your account at any time. We may also terminate accounts that violate these terms 
              or engage in behavior that harms our community. Upon termination, your data will be deleted in 
              accordance with our Privacy Policy.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Disclaimers</h2>
            <div className="space-y-4">
              <p className="leading-relaxed">
                While we use advanced AI to suggest compatible matches, we cannot guarantee romantic success or 
                that you will find a partner. Dating involves many factors beyond compatibility algorithms.
              </p>
              <p className="leading-relaxed">
                June is not responsible for actions taken by other users, meetings arranged through the platform, 
                or relationships that develop outside the app.
              </p>
            </div>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Changes to Terms</h2>
            <p className="leading-relaxed">
              We may update these Terms of Service from time to time to reflect changes in our service or legal 
              requirements. We'll notify you of significant changes via SMS or through the app.
            </p>
          </section>

          <section className="space-y-4">
            <h2 className="text-2xl font-semibold text-black">Contact Us</h2>
            <div className="bg-white/20 p-6 rounded-lg border border-gray-300">
              <p className="leading-relaxed mb-4">
                Have questions about these terms or need support with your account? We're here to help.
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