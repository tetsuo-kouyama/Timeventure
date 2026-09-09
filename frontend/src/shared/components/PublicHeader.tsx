import { Button } from "@/components/ui/button"

export function PublicHeader() {
  return (
    <header className="border-b">
      <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-6">
        <p className="text-xl font-bold">Timeventure</p>

        <div className="flex gap-3">
          <Button variant="outline">ログイン</Button>
          <Button>新規登録</Button>
        </div>
      </div>
    </header>
  )
}
