import type React from "react"
import type { Viewport } from "next"
import { Analytics } from "@vercel/analytics/next"
import { SpeedInsights } from "@vercel/speed-insights/react"
import { Geist } from "next/font/google"
import { ThemeProvider } from "next-themes"
import { MeshGradientComponent } from "@/components/mesh-gradient"
import "../globals.css"

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
  preload: true,
  display: 'swap',
  fallback: ['system-ui', 'arial'],
})

export default function PrivacyLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="en" suppressHydrationWarning className="dark">
      <body
        className={`${geistSans.className} antialiased max-w-screen min-h-svh bg-slate-1 text-slate-12 opacity-0 duration-75 transition-opacity`}
      >
        <ThemeProvider
          enableSystem={false}
          disableTransitionOnChange
          attribute="class"
          defaultTheme="dark"
          forcedTheme="dark"
        >
          <MeshGradientComponent
            colors={["#F5E6D3", "#E8D5C2", "#D4B8A6", "#C19A7B"]}
            speed={2.5}
            style={{
              position: "fixed",
              top: 0,
              left: 0,
              zIndex: 0,
              width: "100%",
              height: "100%",
            }}
          />

          <div className="w-full relative z-20 flex flex-col min-h-screen">
            <main className="flex justify-center min-h-screen items-start pt-20">
              {children}
            </main>
          </div>
        </ThemeProvider>
        <Analytics />
        <SpeedInsights/>
      </body>
    </html>
  )
}