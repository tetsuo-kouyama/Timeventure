import type { TimerSetting } from "../types/timer";

import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

import {
  MAX_BREAK_MINUTES,
  MIN_BREAK_MINUTES,
  MAX_FOCUS_MINUTES,
  MIN_FOCUS_MINUTES,
  MINUTE_INTERVAL,
} from "../constants/timer";

import { createMinuteOptions } from "../utils/createMinuteOptions";

type Props = {
  setting: TimerSetting
  onChange: (setting: TimerSetting) => void
  onSubmit: () => void
}

// 集中時間の選択肢を作成
// 例: [5, 10, 15, ..., 180]
const focusMinuteOptions = createMinuteOptions(
  MIN_FOCUS_MINUTES,
  MAX_FOCUS_MINUTES,
  MINUTE_INTERVAL,
)

// 休憩時間の選択肢を作成
// 例: [0, 5, 10, ..., 180]
const breakMinuteOptions = createMinuteOptions(
  MIN_BREAK_MINUTES,
  MAX_BREAK_MINUTES,
  MINUTE_INTERVAL,
)

export function TimerSettingForm({
  setting,
  onChange,
  onSubmit,
}: Props) {
  return (
    <form
      onSubmit={(event) => {
        // formの標準送信によるページリロードを防ぐ
        event.preventDefault()

        // 実際の保存処理は親コンポーネントに任せる
        onSubmit()
      }}
      className="space-y-6"
    >
      <div className="space-y-2">
        <Label htmlFor="focus-minutes">
          集中時間
        </Label>

        <Select
          value={String(setting.focus_minutes)}
          onValueChange={(value: string | null) => {
            if (value === null) return;
            // focus_minutesだけ変更し、break_minutesなど他の値はそのまま残す
            onChange({
              ...setting,
              focus_minutes: Number(value),
            })
          }}
        >
          <SelectTrigger id="focus-minutes" className="w-full">
            <SelectValue placeholder="集中時間を選択" />
          </SelectTrigger>

          <SelectContent>
            {focusMinuteOptions.map((minutes) => (
              <SelectItem
                key={minutes}
                value={String(minutes)}
              >
                {minutes}分
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="space-y-2">
        <Label htmlFor="break-minutes">
          休憩時間
        </Label>

        <Select
          value={String(setting.break_minutes)}
          onValueChange={(value: string | null) => {
            if (value === null) return
            // break_minutesだけ変更する
            onChange({
              ...setting,
              break_minutes: Number(value),
            })
          }}
        >
          <SelectTrigger id="break-minutes" className="w-full">
            <SelectValue placeholder="休憩時間を選択" />
          </SelectTrigger>

          <SelectContent>
            {breakMinuteOptions.map((minutes) => (
              <SelectItem
                key={minutes}
                value={String(minutes)}
              >
                {minutes}分
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <Button type="submit">
        保存する
      </Button>
    </form>
  )
}
