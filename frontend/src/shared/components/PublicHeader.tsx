import { Link } from "react-router-dom"
import { Button, buttonVariants } from "@/components/ui/button"

export function PublicHeader() {
  return (
    <header className="border-b">
      <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-6">
        <Link to="/" className="text-xl font-bold">
          Timeventure
        </Link>

        <div className="flex gap-3">
          <Button variant="outline">ログイン</Button>

          <Link to="/signup" className={buttonVariants()}>
            新規登録
          </Link>
        </div>
      </div>
    </header>
  )
}
