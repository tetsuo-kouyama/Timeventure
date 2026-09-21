class TimerSession < ApplicationRecord
  class AlreadyRunningError < StandardError; end
  class NotRunningFocusError < StandardError; end
  class NotRunningBreakError < StandardError; end
  class FocusNotFinishedError < StandardError; end

  MAX_FOCUS_MINUTES = 180  # 最大集中時間
  MIN_FOCUS_MINUTES = 5    # 最小集中時間
  MAX_BREAK_MINUTES = 180  # 最大休憩時間
  MIN_BREAK_MINUTES = 0    # 最小休憩時間
  MINUTE_INTERVAL = 5      # 分間隔

  belongs_to :user

  has_one :adventure, dependent: :destroy

  enum :phase, {
    focus: 0,
    break: 1
  }, validate: true

  enum :status, {
    ongoing: 0,
    completed: 1,
    interrupted: 2
  }, validate: true

  validates :focus_minutes,
            numericality: {
              only_integer: true,
              in: MIN_FOCUS_MINUTES..MAX_FOCUS_MINUTES
            }
  validates :break_minutes,
            numericality: {
              only_integer: true,
              in: MIN_BREAK_MINUTES..MAX_BREAK_MINUTES
            }
  validates :phase_started_at, presence: true
  validates :phase_ends_at, presence: true

  validate :minutes_must_match_interval
  validate :phase_ends_at_must_be_after_start

  # タイマーを開始する処理
  def self.start_for!(user:)
    timer_setting = user.timer_setting
    started_at = Time.current

    transaction do
      if user.timer_sessions.ongoing.exists?
        raise AlreadyRunningError, "すでに実行中のタイマーがあります"
      end

      timer_session = user.timer_sessions.create!(
        focus_minutes: timer_setting.focus_minutes,
        break_minutes: timer_setting.break_minutes,
        phase: :focus,
        status: :ongoing,
        phase_started_at: started_at,
        phase_ends_at: started_at + timer_setting.focus_minutes.minutes
      )

      Adventure.start_for!(timer_session: timer_session)

      timer_session
    end
  end

  # 集中タイマーの終了
  def complete_focus!
    finish_focus!(status: :completed)
  end

  # 集中タイマーの中断
  def interrupt!
    finish_focus!(status: :interrupted)
  end

  # 休憩タイマーの終了
  def finish_break!
    with_lock do
      unless break? && ongoing?
        raise NotRunningBreakError, "実行中の休憩タイマーはありません"
      end
      update!(status: :completed)
    end
  end

  private

  def minutes_must_match_interval
    if focus_minutes.present? && !focus_minutes.multiple_of?(MINUTE_INTERVAL)
      errors.add(:focus_minutes, "は#{MINUTE_INTERVAL}分単位で指定してください")
    end

    if break_minutes.present? && !break_minutes.multiple_of?(MINUTE_INTERVAL)
      errors.add(:break_minutes, "は#{MINUTE_INTERVAL}分単位で指定してください")
    end
  end

  # 終了予定時刻が開始時刻より前にならないことをチェックする
  def phase_ends_at_must_be_after_start
    return if phase_started_at.blank? || phase_ends_at.blank?

    if phase_ends_at <= phase_started_at
      errors.add(:phase_ends_at, "は開始時刻より後にしてください")
    end
  end

  # タイマーを終了する処理
  def finish_focus!(status:)
    with_lock do
      unless focus? && ongoing?
        raise NotRunningFocusError, "実行中のタイマーはありません"
      end

      now = Time.current

      if status == :completed && now < phase_ends_at
        raise FocusNotFinishedError, "タイマーはまだ終了していません"
      end

      # 終了予定時刻を過ぎていた場合は通常終了として扱う
      if now >= phase_ends_at
        ended_at = phase_ends_at
        status = :completed
      else
        ended_at = now
      end

      generated_events = adventure.finish!(
        ended_at: ended_at,
        status: status
      )

      if status == :interrupted
        update!(status: :interrupted)
      elsif break_minutes.zero?
        update!(status: :completed)
      else
        break_started_at = phase_ends_at
        update!(
          phase: :break,
          phase_started_at: break_started_at,
          phase_ends_at: break_started_at + break_minutes.minutes
        )
      end
      generated_events
    end
  end
end
