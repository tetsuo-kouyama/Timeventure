import { useEffect, useState } from "react"

import {
  getTimerSetting,
  updateTimerSetting,
} from "@/features/timer/api/timerSettingApi"

import { TimerSettingForm } from "@/features/timer/components/TimerSettingForm"
import type { TimerSetting } from "@/features/timer/types/timer"

export function TimerSettingsPage() {
  const [setting, setSetting] = useState<TimerSetting | null>(null)
  const [message, setMessage] = useState("")
  const [error, setError] = useState("")

  // 現在のタイマー設定を取得
  useEffect(() => {
    const fetchTimerSetting = async () => {
      try {
        const data = await getTimerSetting()
        setSetting(data.timer_setting)
      } catch {
        setError("タイマー設定の取得に失敗しました")
      }
    }

    fetchTimerSetting()
  }, [])

  // タイマー設定を保存
  const handleSubmit = async () => {
    if (!setting) return

    try {
      setMessage("")
      setError("")

      const data = await updateTimerSetting(setting)

      setSetting(data.timer_setting)
      setMessage("タイマー設定を更新しました")
    } catch {
      setError("タイマー設定の更新に失敗しました")
    }
  }

  if (!setting) {
    return (
      <div className="mx-auto max-w-xl">
        <h1 className="text-2xl font-bold">
          タイマー設定
        </h1>

        {error ? (
          <p className="mt-4 text-red-500">
            {error}
          </p>
        ) : (
          <p className="mt-4">
            読み込み中...
          </p>
        )}
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-xl">
      <h1 className="text-2xl font-bold">
        タイマー設定
      </h1>

      <p className="mt-2 text-muted-foreground">
        集中時間と休憩時間を設定できます。
      </p>

      {message && (
        <div className="mt-6 rounded-md border p-4">
          {message}
        </div>
      )}

      {error && (
        <div className="mt-6 rounded-md border border-red-500 p-4 text-red-500">
          {error}
        </div>
      )}

      <div className="mt-8">
        <TimerSettingForm
          setting={setting}
          onChange={setSetting}
          onSubmit={handleSubmit}
        />
      </div>
    </div>
  )
}
