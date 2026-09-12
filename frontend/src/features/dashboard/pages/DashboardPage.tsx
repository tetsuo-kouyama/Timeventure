import { useEffect, useState } from "react"
import { Link, useLocation, useNavigate } from "react-router-dom"
import { buttonVariants } from "@/components/ui/button"

import { getTimerSetting } from "@/features/timer/api/timerSettingApi"
import { TimerDisplay } from "@/features/timer/components/TimerDisplay"
import type { TimerSetting } from "@/features/timer/types/timer"

export function DashboardPage() {
  const location = useLocation()
  const navigate = useNavigate()

  const [message, setMessage] = useState(location.state?.message ?? "")
  const [timerSetting, setTimerSetting] = useState<TimerSetting | null>(null)

  // ログイン後などのメッセージを3秒間表示する処理
  useEffect(() => {
    if (!message) return

    // 履歴上のstateを消す
    navigate(location.pathname, {
      replace: true,
      state: {},
    })

    // 3秒後に画面から消す
    const timer = setTimeout(() => {
      setMessage("")
    }, 3000)

    return () => clearTimeout(timer)
  }, [message, navigate, location.pathname])

  // タイマー設定を取得する処理
  useEffect(() => {
    const fetchTimerSetting = async () => {
      const data = await getTimerSetting()
      setTimerSetting(data.timer_setting)
    }

    fetchTimerSetting()
  }, [])

  return (
    <>
      {message && (
        <div className="mb-4 rounded-md border p-4">
          {message}
        </div>
      )}

      <div className="mx-auto max-w-3xl">
        <div className="flex items-center justify-between">
          <h1 className="text-2xl font-bold">集中タイマー</h1>
          <Link 
            to="/timer-setting" 
            className={buttonVariants({ variant: "outline" })}
          >
            設定
          </Link>
        </div>
        

        {timerSetting ? (
          <>
            <TimerDisplay minutes={timerSetting.focus_minutes} />

            <div className="mt-6 flex justify-center gap-8">
              <p>
                集中タイマー: {timerSetting.focus_minutes}分
              </p>

              <p>
                休憩タイマー: {timerSetting.break_minutes}分
              </p>
            </div>
          </>
        ) : (
          <p className="mt-6">
            読み込み中...
          </p>
        )}
      </div>
    </>
  )
}
