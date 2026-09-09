import { Button } from "@/components/ui/button"

export function HomePage() {
  return (
    <main className="flex flex-1 items-center justify-center px-6">
      <div className="text-center">
        <h1 className="text-5xl font-bold tracking-tight">
          Timeventure
        </h1>

        <p className="mt-4 text-xl text-muted-foreground">
          タイマーを冒険に変えよう
        </p>

        <Button size="lg" className="mt-10 px-12 py-6 text-lg">
          ゲストで始める
        </Button>
      </div>
    </main>
  )
}
