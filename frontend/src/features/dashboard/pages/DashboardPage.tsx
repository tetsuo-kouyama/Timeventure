import { useEffect, useState } from "react"
import { useLocation, useNavigate } from "react-router-dom"
import { SidebarProvider } from "@/components/ui/sidebar"
import { AppSidebar } from "@/shared/components/AppSidebar"

export function DashboardPage() {
  const location = useLocation()
  const navigate = useNavigate()

  const [message, setMessage] = useState(location.state?.message ?? "")

  useEffect(() => {
    if (!message) return

    // 履歴上のstateを消す
    navigate(location.pathname, {
      replace: true,
      state: {},
    })

    // 3秒後に画面から消す
    const timer = setTimeout(() => {
      setMessage("")
    }, 3000)

    return () => clearTimeout(timer)
  }, [message, navigate, location.pathname])

  return (
    <SidebarProvider>
      <AppSidebar />

      <main className="flex-1 p-8">
        {message && (
          <div className="mb-4 rounded-md border p-4">
            {message}
          </div>
        )}

        <h1 className="text-2xl font-bold">
          ダッシュボード
        </h1>

        <p className="mt-4 text-gray-500">
          Timeventureへようこそ
        </p>
      </main>
    </SidebarProvider>
  )
}
