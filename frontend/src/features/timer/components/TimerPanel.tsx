import { useEffect, useState } from "react";
import { SECONDS_PER_MINUTE } from "../constants/timer";
import type { TimerSetting } from "../types/timer";
import { TimerDisplay } from "./TimerDisplay";
import { Button } from "@/components/ui/button";

type Props = {
  setting: TimerSetting // 設定値
}

export function TimerPanel({ setting }: Props) {

  // タイマーのモード（"focus": 集中 / "break": 休憩）
  // const [mode, setMode] = useState<TimerMode>("focus")

  // タイマーの稼働状態（true: 実行中 / false: 停止中）
  const [isRunning, setIsRunning] = useState(false)

  // 残り秒数（例：25分 → 1500秒）
  const [remainingSeconds, setRemainingSeconds] = useState(
    setting.focus_minutes * SECONDS_PER_MINUTE
  )

  // スタートボタン押下時の処理
  const handleStart = () => {
    setIsRunning(true)  // 「実行中」に変更
  }

  // タイマー実行中は1秒ごとに残り時間を減らす
  useEffect(() => {
    if (!isRunning) return

    const timer = setInterval(() => {
      setRemainingSeconds((prev) => {
        if (prev <= 0) {
          return 0
        }

        return prev - 1
      })
    }, 1000)

    // useEffect のクリーンアップ関数
    return () => {
      clearInterval(timer)
    }
  }, [isRunning])

  return (
    <div>
      <TimerDisplay remainingSeconds={remainingSeconds} />

      {/* 「停止中」は「スタート」を表示 */}
      {!isRunning && (
        <Button type="button" onClick={handleStart}>
          スタート
        </Button>
      )}

      {/* 「実行中」は「中断する」を表示 */}
      {isRunning && (
        <Button type="button" variant="destructive">
          中断する
        </Button>
      )}
    </div>
  )
}
