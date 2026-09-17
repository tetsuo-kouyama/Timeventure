import type { TimerMode } from "../types/timer"
import { formatTimer } from "../utils/formatTimer"

type Props = {
  remainingSeconds: number
  mode: TimerMode
}

export function TimerDisplay({ remainingSeconds, mode }: Props) {
  return (
    <div className="text-center">
      <p className="text-sm text-muted-foreground">
      {mode === "focus" ? "集中タイマー" : "休憩タイマー"}
      </p>

      <p className="mt-2 text-6xl font-bold tabular-nums">
        {formatTimer(remainingSeconds)}
      </p>
    </div>
  )
}
