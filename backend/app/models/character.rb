class Character < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :level, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :gold, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :experience_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :base_hp, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :base_attack, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :base_defense, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :base_speed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :base_luck, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
