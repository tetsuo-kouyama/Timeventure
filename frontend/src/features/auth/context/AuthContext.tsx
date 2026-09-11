// ログイン中のユーザー情報をアプリ全体で共有するための Context 定義

import { createContext } from "react"
import type { User } from "../types/auth"

// AuthContext で共有するデータの型
type AuthContextType = {
  user: User | null    // ログイン中のユーザー情報（未ログイン時は null）
  isLoading: boolean   // 初期ロード状態（true: /api/v1/me 通信中、false: 確認完了）
  refreshUser: () => Promise<void> // ログイン時等に /api/v1/me を再取得して状態を更新する関数
}

// Context そのものを作成
export const AuthContext = createContext<AuthContextType | undefined>(
  undefined
)
