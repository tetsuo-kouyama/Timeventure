// タイマー設定の型を定義
export type TimerSetting = {
  focus_minutes: number
  break_minutes: number
}

// 集中/休憩を判定する
export type TimerMode = "focus" | "break"
