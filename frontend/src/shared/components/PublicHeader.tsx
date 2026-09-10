import { Link } from "react-router-dom"
import { Button } from "@/components/ui/button"

export function PublicHeader() {
  return (
    <header className="border-b">
      <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-6">
        <Link to="/" className="text-xl font-bold">
          Timeventure
        </Link>

        <div className="flex gap-3">
          <Button variant="outline">ログイン</Button>

          <Button asChild>
            <Link to="/signup">新規登録</Link>
          </Button>
        </div>
      </div>
    </header>
  )
}
