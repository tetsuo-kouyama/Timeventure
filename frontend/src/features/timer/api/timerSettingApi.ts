// タイマー設定に関するRails APIとの通信処理をまとめるファイル

import { apiFetch } from "@/lib/api";
import type { TimerSetting } from "../types/timer";

export async function getTimerSetting() {
  const response = await apiFetch("/api/v1/timer_setting")

  if (!response.ok) {
    throw new Error("タイマー設定の取得に失敗しました")
  }

  return response.json()
}

export async function updateTimerSetting(setting: TimerSetting) {
  const response = await apiFetch("/api/v1/timer_setting", {
    method: "PATCH",
    body: JSON.stringify(setting),
  })

  if (!response.ok) {
    throw new Error("タイマー設定の更新に失敗しました")
  }

  return response.json()
}
