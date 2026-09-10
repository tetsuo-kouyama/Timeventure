import { SidebarProvider } from "@/components/ui/sidebar"
import { AppSidebar } from "@/shared/components/AppSidebar"

export function DashboardPage() {
  return (
    <SidebarProvider>
      <AppSidebar />

      <main className="flex-1 p-8">
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
