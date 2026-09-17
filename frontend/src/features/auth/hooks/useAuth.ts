// AuthContext を各コンポーネントから簡単かつ安全に使うためのカスタムフック

import { useContext } from "react"
import { AuthContext } from "../context/AuthContext"

export function useAuth() {
  // user、isLoading、refreshUser を取得
  const context = useContext(AuthContext)

  // AuthProvider の外側から使うとエラーを発生させる
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider")
  }

  return context
}
