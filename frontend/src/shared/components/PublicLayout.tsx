import type { ReactNode } from "react";
import { PublicHeader } from "./PublicHeader";

type PublicLayoutProps = {
  children: ReactNode
}

export function PublicLayout({ children }: PublicLayoutProps) {
  return (
    <div className="flex min-h-screen flex-col">
      <PublicHeader />

      <main className="flex flex-1 items-center justify-center px-4">
        {children}
      </main>
    </div>
  )
}
