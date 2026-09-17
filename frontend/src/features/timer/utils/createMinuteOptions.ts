// 設定時間の選択肢生成処理
export function createMinuteOptions(
  min: number,
  max: number,
  interval: number,
) {
  return Array.from(
    { length: (max - min) / interval + 1 },
    (_, index) => min + index * interval,
  )
}
