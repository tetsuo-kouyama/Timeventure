import type { AdventureResultResponse } from "../types/adventure"

type Props = {
  result: AdventureResultResponse | null
}

export function AdventureResultCard({ result }: Props) {
  return (
    <div>
      <h2>冒険結果</h2>

      {result ? (
        <div>
          <p>倒したモンスター: {result.summary.defeated_enemies_count}体</p>
          <p>獲得経験値: {result.summary.experience_points}</p>
          <p>獲得ゴールド: {result.summary.gold}G</p>
        </div>
      ) : (
        <p>冒険結果はまだありません</p>
      )}
    </div>
  )
}
