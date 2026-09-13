import { Outlet } from "react-router-dom"
import { SidebarProvider } from "@/components/ui/sidebar"
import { AppSidebar } from "@/shared/components/AppSidebar"

export function AppLayout() {
  return (
    <SidebarProvider>
      <AppSidebar />

      <main className="flex-1 p-8">
        {/* この共通レイアウトの中に、現在のページを表示する場所 */}
        <Outlet />
      </main>
    </SidebarProvider>
  )
}
