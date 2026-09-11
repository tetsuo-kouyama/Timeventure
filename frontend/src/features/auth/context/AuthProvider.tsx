// 認証状態を保持し、アプリ全体に提供するプロバイダーコンポーネント

import { useEffect, useState, type ReactNode } from "react"
import { apiFetch } from "@/lib/api"
import type { User } from "../types/auth"
import { AuthContext } from "./AuthContext"

// AuthProvider の内側に React コンポーネントを入れられるようにする型
type AuthProviderProps = {
  children: ReactNode
}

export function AuthProvider({ children }: AuthProviderProps) {
  const [user, setUser] = useState<User | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  // Railsが持っている最新のログイン状態を取得して、React側の認証状態を最新にするための関数
  const refreshUser = async () => {
    const response = await apiFetch("/api/v1/me")

    // レスポンスが返ってきたら Context にユーザーを保存
    if (response.ok) {
      const data = await response.json()
      setUser(data.user)
    } else {
      setUser(null)
    }
  }

  // AuthProvider が最初に表示されたタイミングで /api/v1/me を呼ぶ
  useEffect(() => {
    const fetchCurrentUser = async () => {
      try {
        await refreshUser()

      // 成功・失敗に関わらず最後に実行される
      } finally {
        setIsLoading(false)
      }
    }

    fetchCurrentUser()

  // 依存配列が空の場合、基本的にコンポーネントが最初にマウントされたときに実行する
  // AuthProvider がマウントされると、一度だけ useEffect が実行される
  }, [])

  return (
    // user、isLoading、refreshUser を子コンポーネントに共有
    <AuthContext.Provider value={{ user, isLoading, refreshUser }}>
      {children}
    </AuthContext.Provider>
  )
}
