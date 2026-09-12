import { useAuth } from "@/features/auth/hooks/useAuth"
import { Sidebar, SidebarHeader, SidebarContent, SidebarFooter } from "@/components/ui/sidebar"
import { Button } from "@/components/ui/button"
import { useState } from "react"

export function AppSidebar() {
  const { logout } = useAuth()
  const [error, setError] = useState("")

  const handleLogout = async () => {
    setError("")

    try {
      await logout()
    } catch {
      setError("ログアウトに失敗しました")
    }
  }

  return (
    <Sidebar>
      <SidebarHeader>
        <span className="px-2 py-2 text-xl font-bold">
          Timeventure
        </span>
      </SidebarHeader>

      <SidebarContent>
        {/* タイマー設定などのメニュー */}
      </SidebarContent>

      <SidebarFooter className="border-t">
        {error && (
          <div className="rounded-md border border-destructive/50 bg-destructive/10 p-4">
            <p className="text-sm text-destructive">
              {error}
            </p>
          </div>
        )}

        <Button
          type="button"
          variant="ghost"
          className="justify-start"
          onClick={handleLogout}
        >
          ログアウト
        </Button>
      </SidebarFooter>
    </Sidebar>
  )
}
