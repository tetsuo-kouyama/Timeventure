import { useState } from "react";
import { useNavigate } from "react-router-dom"
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { apiFetch } from "@/lib/api";

export function LoginForm() {
  const [emailAddress, setEmailAddress] = useState("")
  const [password, setPassword] = useState("")
  const [errors, setErrors] = useState<string[]>([])
  const navigate = useNavigate()

  const handleSubmit: React.SubmitEventHandler<HTMLFormElement> = async (e) => {
    e.preventDefault()

    setErrors([])

    const response = await apiFetch("/api/v1/session", {
      method: "POST",
      body: JSON.stringify({
        email_address: emailAddress,
        password,
      }),
    })

    const data = await response.json()

    if (response.ok) {
      navigate("/dashboard")
    } else {
      setErrors(data.message ?? ["ログインに失敗しました"])
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      {errors.length > 0 && (
        <div className="rounded-md border border-destructive/50 bg-destructive/10 p-4">
          <ul className="space-y-1 text-sm text-destructive">
            {errors.map((error) => (
              <li key={error}>{error}</li>
            ))}
          </ul>
        </div>
      )}
      <div className="space-y-2">
        <Label htmlFor="email_address">
          メールアドレス
        </Label>

        <Input
          id="email_address"
          type="email"
          value={emailAddress}
          onChange={(e) => setEmailAddress(e.target.value)}
          required
        />
      </div>

      <div className="space-y-2">
        <Label htmlFor="password">
          パスワード
        </Label>

        <Input
          id="password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
          minLength={6}
        />
      </div>

      <Button type="submit" className="w-full">
        ログイン
      </Button>
    </form>
  )
}
