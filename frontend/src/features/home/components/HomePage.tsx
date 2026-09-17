import {useState } from "react"
import { useNavigate } from "react-router-dom"
import { apiFetch } from "@/lib/api"
import { useAuth } from "@/features/auth/hooks/useAuth"
import { Button } from "@/components/ui/button"

export function HomePage() {
  const navigate = useNavigate()
  const { refreshUser } = useAuth()
  const [error, setError] = useState("")

  const handleGuestLogin = async () => {
    setError("")

    const response = await apiFetch("/api/v1/guest_login", {
      method: "POST",
    })

    const data = await response.json()

    if (response.ok) {
      await refreshUser()

      navigate("/dashboard", {
        state: {
          message: data.message,
        },
      })
    } else {
      setError(data.message ?? "ゲストログインに失敗しました")
    }
  }
  return (
    <main className="flex flex-1 items-center justify-center px-6">
      <div className="text-center">
        <h1 className="text-5xl font-bold tracking-tight">
          Timeventure
        </h1>

        <p className="mt-4 text-xl text-muted-foreground">
          タイマーを冒険に変えよう
        </p>

        {error && (
          <p className="mt-4 text-sm text-destructive">
            {error}
          </p>
        )}

        <Button
          type="button"
          size="lg"
          className="mt-10 px-12 py-6 text-lg"
          onClick={handleGuestLogin}
        >
          ゲストで始める
        </Button>
      </div>
    </main>
  )
}
