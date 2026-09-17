import { useEffect, useState } from "react"
import { useLocation, useNavigate } from "react-router-dom"

import { getTimerSetting } from "@/features/timer/api/timerSettingApi"
import type { TimerSetting } from "@/features/timer/types/timer"
import { TimerPanel } from "@/features/timer/components/TimerPanel"

import type { AdventureResultResponse } from "@/features/adventure/types/adventure"
import { AdventureResultCard } from "@/features/adventure/components/AdventureResultCard"

import { getCharacter } from "@/features/character/api/characterApi"
import type { Character } from "@/features/character/types/character"
import { CharacterStatusCard } from "@/features/character/components/CharacterStatusCard"

export function DashboardPage() {
  const location = useLocation()
  const navigate = useNavigate()

  const [message, setMessage] = useState(location.state?.message ?? "")
  const [timerSetting, setTimerSetting] = useState<TimerSetting | null>(null)

  // 完了・中断した冒険の結果
  const [adventureResult, setAdventureResult] =
    useState<AdventureResultResponse | null>(null)

  // キャラクター情報を取得する（null: 取得前 / Character: API取得後）
  const [character, setCharacter] = useState<Character | null>(null)

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

  // ダッシュボードを開いた時の初回表示
  useEffect(() => {
    const fetchCharacter = async () => {
      const data = await getCharacter()
      setCharacter(data.character)
    }
    fetchCharacter()
  }, [])

  // 冒険終了・中断後の再取得
  const handleAdventureResult = async (result: AdventureResultResponse) => {
    setAdventureResult(result)

    const data = await getCharacter()
    setCharacter(data.character)
  }

  return (
    <>
      {message && (
        <div className="mb-4 rounded-md border p-4">
          {message}
        </div>
      )}

      <div className="mx-auto max-w-3xl">
        {timerSetting ? (
            <div className="mt-6 grid gap-6 md:grid-cols-2">
              <div className="md:col-span-2">
                <TimerPanel
                  setting={timerSetting}
                  onAdventureResult={handleAdventureResult}
                />
              </div>

              <AdventureResultCard result={adventureResult} />

              {character && (
                <CharacterStatusCard character={character} />
               )}
            </div>
        ) : (
          <p className="mt-6">
            読み込み中...
          </p>
        )}
      </div>
    </>
  )
}
