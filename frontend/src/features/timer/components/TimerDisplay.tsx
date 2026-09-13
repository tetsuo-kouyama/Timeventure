type Props = {
  minutes: number
}

export function TimerDisplay({ minutes }: Props) {
  const formattedMinutes = String(minutes).padStart(2, "0")

  return (
    <div className="text-center">
      <p className="text-sm text-muted-foreground">
        集中タイマー
      </p>

      <p className="mt-2 text-6xl font-bold tabular-nums">
        {formattedMinutes}:00
      </p>
    </div>
  )
}
