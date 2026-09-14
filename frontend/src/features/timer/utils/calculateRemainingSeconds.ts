// 残り秒数を終了予定時刻から求める関数
export function calculateRemainingSeconds(endTime: number) {
  const diff = endTime - Date.now()

  return Math.max(
    0,
    Math.ceil(diff / 1000)
  )
}
