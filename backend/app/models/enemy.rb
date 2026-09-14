class Enemy < ApplicationRecord
  has_many :area_enemies, dependent: :restrict_with_error
  has_many :areas, through: :area_enemies

  validates :name, presence: true
  validates :base_hp, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :base_attack, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :base_defense, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :base_speed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :base_luck, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :drop_gold, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :drop_experience_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
