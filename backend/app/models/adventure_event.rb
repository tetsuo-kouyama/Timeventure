class AdventureEvent < ApplicationRecord
  belongs_to :adventure

  enum :event_type, {
    battle: 0,
    treasure: 1
  }, validate: true

  validates :elapsed_seconds,
          numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :event_index,
          numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
