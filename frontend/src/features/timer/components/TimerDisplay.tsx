import { formatTimer } from "../utils/formatTimer"

type Props = {
  remainingSeconds: number
}

export function TimerDisplay({ remainingSeconds }: Props) {
  return (
    <div className="text-center">
      <p className="text-sm text-muted-foreground">
        集中タイマー
      </p>

      <p className="mt-2 text-6xl font-bold tabular-nums">
        {formatTimer(remainingSeconds)}
      </p>
    </div>
  )
}
