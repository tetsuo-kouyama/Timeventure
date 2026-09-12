class TimerSetting < ApplicationRecord
  belongs_to :user

  MAX_FOCUS_MINUTES = 180  # 最大集中時間
  MIN_FOCUS_MINUTES = 5    # 最小集中時間
  MAX_BREAK_MINUTES = 180  # 最大休憩時間
  MIN_BREAK_MINUTES = 0    # 最小休憩時間
  MINUTE_INTERVAL = 5      # 分間隔

  validates :focus_minutes,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: MIN_FOCUS_MINUTES,
              less_than_or_equal_to: MAX_FOCUS_MINUTES
            }
  validates :break_minutes,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: MIN_BREAK_MINUTES,
              less_than_or_equal_to: MAX_BREAK_MINUTES
            }
  validate :minutes_must_match_interval

  private

  # 分数が設定された間隔に一致するかチェック
  def minutes_must_match_interval
    if focus_minutes.present? && !focus_minutes.multiple_of?(MINUTE_INTERVAL)
      errors.add(:focus_minutes, "は#{MINUTE_INTERVAL}分単位で指定してください")
    end

    if break_minutes.present? && !break_minutes.multiple_of?(MINUTE_INTERVAL)
      errors.add(:break_minutes, "は#{MINUTE_INTERVAL}分単位で指定してください")
    end
  end
end
