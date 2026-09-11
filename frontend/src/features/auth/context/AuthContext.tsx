// ログイン中のユーザー情報をアプリ全体で共有するための仕組み

import {
  createContext,
  useEffect,
  useState,
  type ReactNode,
} from "react"

import { apiFetch } from "@/lib/api"
import type { User } from "../types/auth"

// AuthContext で共有するデータの型
type AuthContextType = {
  user: User | null
  isLoading: boolean
}

// Context そのものを作成
export const AuthContext = createContext<AuthContextType | undefined>(
  undefined
)

// AuthProvider の内側に React コンポーネントを入れられるようにする型
type AuthProviderProps = {
  children: ReactNode
}

export function AuthProvider({ children }: AuthProviderProps) {
  const [user, setUser] = useState<User | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  // AuthProvider が最初に表示されたタイミングで /api/v1/me を呼ぶ
  useEffect(() => {
    const fetchCurrentUser = async () => {
      try {
        const response = await apiFetch("/api/v1/me")

        // レスポンスが返ってきたら Context にユーザーを保存
        if (response.ok) {
          const data = await response.json()
          setUser(data.user)
        } else {
          setUser(null)
        }
      // 成功・失敗に関わらず最後に実行される
      } finally {
        setIsLoading(false)
      }
    }

    fetchCurrentUser()

  // 依存配列が空の場合、基本的にコンポーネントが最初にマウントされたときに実行する
  // AuthProvider がマウントされると、一度だけ useEffect が実行される
  }, [])

  // user と isLoading を子コンポーネントに共有
  return (
    <AuthContext.Provider value={{ user, isLoading }}>
      {children}
    </AuthContext.Provider>
  )
}
