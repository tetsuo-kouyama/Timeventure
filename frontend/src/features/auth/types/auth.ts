// GET /api/v1/me から返ってくるログインユーザー情報の型定義

export type User = {
  id: number
  email_address: string
  guest: boolean
}
