class Adventure < ApplicationRecord
  belongs_to :character
  belongs_to :start_area, class_name: "Area"

  enum :status, {
    ongoing: 0,
    completed: 1,
    interrupted: 2
  }, validate: true

  validates :planned_focus_minutes,
            numericality: { only_integer: true, in: 5..180 }

  validates :random_seed,
            numericality: { only_integer: true }

  validates :started_at, presence: true
end
