// Rails 側で定義している Enum と TypeScript の型定義を一致させる
export type AdventureStatus = "ongoing" | "completed" | "interrupted"

// 冒険作成時のデータ型
export type Adventure = {
  id: number                      // 冒険ID
  status: AdventureStatus         // ステータス（進行中・完了・中断）
  started_at: string              // 開始時刻
  planned_focus_minutes: number   // 設定した時間（分）
}

// 冒険作成APIのレスポンス型
export type CreateAdventureResponse = {
  adventure: Adventure  // 作成された冒険オブジェクト
}

// 冒険結果（完了・中断時）のデータ型
export type AdventureResult = {
  id: number                     // 冒険ID
  status: AdventureStatus        // 最終ステータス（"completed" | "interrupted"）
  started_at: string             // 開始日時（ISO8601形式の文字列）
  ended_at: string               // 終了日時（ISO8601形式の文字列）
  generated_events_count: number // 発生したイベントの総数
}

// 冒険結果集計用データ
export type AdventureSummary = {
  defeated_enemies_count: number
  experience_points: number
  gold: number
}

// 冒険完了・中断APIのレスポンス型
export type AdventureResultResponse = {
  adventure: AdventureResult  // 冒険結果オブジェクト
  summary: AdventureSummary
}
