class Adventure < ApplicationRecord
  belongs_to :timer_session
  belongs_to :character
  belongs_to :start_area, class_name: "Area"

  has_many :adventure_events, dependent: :destroy

  enum :status, {
    ongoing: 0,
    completed: 1,
    interrupted: 2
  }, validate: true

  validates :planned_focus_minutes,
            numericality: { only_integer: true, in: 5..180 }

  validates :random_seed,
            numericality: { only_integer: true }

  validates :next_event_index,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  validates :started_at, presence: true

  # 冒険を開始する処理
  def self.start_for!(character:)
    character.adventures.create!(
      start_area: Area.find_by(name: "草原"),
      planned_focus_minutes: character.user.timer_setting.focus_minutes,
      status: :ongoing,
      random_seed: SecureRandom.random_number(2**63),
      started_at: Time.current
    )
  end

  # 冒険を終了させる処理
  def finish!(ended_at:, status:)
    generated_events = []

    transaction do
      update!(ended_at: ended_at)

      generated_events = AdventureEventGenerator.new(self).call

      update!(status: status)
    end
    generated_events  # 作成したイベントを返す
  end
end
