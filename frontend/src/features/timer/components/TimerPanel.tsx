import { useEffect, useState } from "react";
import { SECONDS_PER_MINUTE } from "../constants/timer";
import type { TimerMode, TimerSetting } from "../types/timer";
import { TimerDisplay } from "./TimerDisplay";
import { Button } from "@/components/ui/button";
import { InterruptTimerDialog } from "./InterruptTimerDialog";
import { calculateRemainingSeconds } from "../utils/calculateRemainingSeconds";
import { completeAdventure, createAdventure, interruptAdventure } from "@/features/adventure/api/adventureApi";
import type { AdventureResultResponse } from "@/features/adventure/types/adventure";

type Props = {
  setting: TimerSetting // 設定値
  onAdventureResult: (result: AdventureResultResponse) => void
}

export function TimerPanel({ setting, onAdventureResult }: Props) {

  // タイマーのモード（"focus": 集中 / "break": 休憩）
  const [mode, setMode] = useState<TimerMode>("focus")

  // タイマーの稼働状態（true: 実行中 / false: 停止中）
  const [isRunning, setIsRunning] = useState(false)

  // 残り秒数（例：25分 → 1500秒）
  const [remainingSeconds, setRemainingSeconds] = useState(
    setting.focus_minutes * SECONDS_PER_MINUTE
  )

  // タイマーの終了予定時刻
  const [endTime, setEndTime] = useState<number | null>(null)

  // モーダルの開閉状態（true: 開く / false: 閉じる）
  const [isInterruptDialogOpen, setIsInterruptDialogOpen] = useState(false)

  // 開始時の Adventure と、完了・中断時の Adventure を結び付けるためのID
  const [adventureId, setAdventureId] = useState<number | null>(null)

  // エラー用 state （null: エラーなし / string: エラーあり）
  const [error, setError] = useState<string | null>(null)

  // 「Adventure作成中」を表す state
  const [isStarting, setIsStarting] = useState(false)

  // Adventure完了APIの処理中かどうか
  const [isCompleting, setIsCompleting] = useState(false)

  // Adventure中断APIの処理中かどうか
  const [isInterrupting, setIsInterrupting] = useState(false)

  // スタートボタン押下時の処理
  const handleStart = async () => {
    setError(null)
    setIsStarting(true)

    try {
      const data = await createAdventure()

      // 作成された Adventure IDを保持
      setAdventureId(data.adventure.id)

      // 終了予定時刻を設定
      const durationMilliseconds = remainingSeconds * 1000
      setEndTime(Date.now() + durationMilliseconds)

      setIsRunning(true)   // 「実行中」に変更
    } catch {
      setError("冒険の開始に失敗しました")
    } finally {
      setIsStarting(false)
    }
  }



  // タイマーを止める共通処理
  const resetTimer = () => {
    setMode("focus")
    setIsRunning(false)
    setRemainingSeconds(
      setting.focus_minutes * SECONDS_PER_MINUTE
    )
    setEndTime(null)
    setAdventureId(null)
  }

  // 中断時の処理
  const handleInterrupt = async () => {
    if (adventureId === null) return
    if (isInterrupting) return

    setIsInterrupting(true)
    setError(null)

    try{
      const data = await interruptAdventure(adventureId)

      // 中断時の冒険結果を保持
      onAdventureResult(data)

      // API成功後にタイマーを初期状態に戻す
      resetTimer()

      // 中断確認ダイアログを閉じる
      setIsInterruptDialogOpen(false)
    } catch {
      setError("冒険の中断に失敗しました")
    } finally {
      setIsInterrupting(false)
    }
  }

  // タイマー実行中の処理
  useEffect(() => {
    if (!isRunning) return
    if (endTime === null) return

    // 完了時の処理
    const handleComplete = async (completedAt: number) => {
      if (adventureId === null) return
      if (isCompleting) return

      setIsCompleting(true)
      setError(null)

      try {
        const data = await completeAdventure(adventureId)

        // 冒険結果を保持
        onAdventureResult(data)

        // 休憩時間が0分の場合はタイマーを終了
        if (setting.break_minutes === 0) {
          setMode("focus")
          setIsRunning(false)
          setRemainingSeconds(
            setting.focus_minutes * SECONDS_PER_MINUTE
          )
          setEndTime(null)
          setAdventureId(null)
          return
        }
        
        // 休憩タイマーを開始
        const breakSeconds = setting.break_minutes * SECONDS_PER_MINUTE
        setMode("break")
        setRemainingSeconds(breakSeconds)
        setEndTime(completedAt + breakSeconds * 1000)
      } catch {
        setError("冒険の完了に失敗しました")
      } finally {
        setIsCompleting(false)
      }
    }

    const timer = setInterval(() => {
      const remaining = calculateRemainingSeconds(endTime)

      if (remaining > 0) {
        setRemainingSeconds(remaining)
        return
      }

      if (mode === "focus") {
        void handleComplete(Date.now())
        return
      }

      if (mode === "break") {
        setMode("focus")
        setIsRunning(false)
        setRemainingSeconds(
         setting.focus_minutes * SECONDS_PER_MINUTE
        )
        setEndTime(null)
        setAdventureId(null)
      }
    }, 1000)

    // useEffect のクリーンアップ関数
    return () => {
      clearInterval(timer)
    }
  }, [
    isRunning,
    endTime,
    mode,
    setting.break_minutes,
    adventureId,
    isCompleting,
    onAdventureResult,
    setting.focus_minutes,
  ])

  return (
    <div className="flex flex-col items-center gap-8">
      <TimerDisplay remainingSeconds={remainingSeconds} mode={mode} />

      <div className="mt-8 flex gap-12 text-sm text-muted-foreground">
        <p>集中タイマー: {setting.focus_minutes}分</p>
        <p>休憩タイマー: {setting.break_minutes}分</p>
      </div>


      {/* 中断処理を子に渡す */}
      <InterruptTimerDialog
        open={isInterruptDialogOpen}
        onOpenChange={setIsInterruptDialogOpen}
        onInterrupt={handleInterrupt}
        isInterrupting={isInterrupting}
      />

      {/* エラー表示 */}
      {error && (
        <p className="text-sm text-destructive">
          {error}
        </p>
      )}

      <div className="mt-5">

        {/* 「停止中」は「スタート」を表示 */}
        {!isRunning && (
          <Button
            type="button"
            onClick={handleStart}
            disabled={isStarting}
          >
          {isStarting ? "開始中..." : "スタート"}
          </Button>
        )}

        {/* 「focus中」は「中断する」を表示  */}
        {isRunning && mode === "focus" && (
          <Button
            type="button"
            variant="destructive"
            onClick={() => setIsInterruptDialogOpen(true)}
          >
            中断する
          </Button>
        )}

        {/* 「break中」は「終了する」を表示」 */}
        {isRunning && mode === "break" && (
          <Button type="button" onClick={resetTimer}>
            終了する
          </Button>
        )}
      </div>
    </div>
  )
}
