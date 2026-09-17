import { useState } from "react"
import { NavLink } from "react-router-dom"
import { LayoutDashboard, Timer, LogOut } from "lucide-react"

import { useAuth } from "@/features/auth/hooks/useAuth"

import {
  Sidebar,
  SidebarHeader,
  SidebarContent,
  SidebarFooter,
} from "@/components/ui/sidebar"
import { Button } from "@/components/ui/button"

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

  const linkClassName =
    "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium hover:bg-sidebar-accent"


  return (
    <Sidebar>
      <SidebarHeader>
        <span className="px-2 py-2 text-xl font-bold">
          Timeventure
        </span>
      </SidebarHeader>

      <SidebarContent className="px-2">
        <nav className="space-y-1">
          <NavLink
            to="/dashboard"
            className={linkClassName}
          >
            <LayoutDashboard className="size-4" />
            <span>ダッシュボード</span>
          </NavLink>

          <NavLink
            to="/timer-setting"
            className={linkClassName}
          >
            <Timer className="size-4" />
            <span>タイマー設定</span>
          </NavLink>
        </nav>
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
          <LogOut className="size-4" />
          ログアウト
        </Button>
      </SidebarFooter>
    </Sidebar>
  )
}
