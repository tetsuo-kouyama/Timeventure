import { Navigate, Outlet } from "react-router-dom"
import { useAuth } from "../hooks/useAuth"

export function ProtectedRoute() {
  // 認証情報を取得
  const { user, isLoading } = useAuth()

  // 現在のログイン状態を確認中
  // GET /api/v1/me が終了（isLoading: false）すると次に進む
  if (isLoading) {
    return <div>読み込み中...</div>
  }

  // 未ログインならログイン画面へ移動
  if (!user) {
    return <Navigate to="/login" replace/>
  }

  // ログイン済みなら子ルートを表示
  return <Outlet />
}
