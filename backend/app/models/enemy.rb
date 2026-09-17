class Enemy < ApplicationRecord
  HP_GROWTH  = 2
  ATK_GROWTH = 1
  DEF_GROWTH = 1

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

  def hp(level)
    calculate_stat(base_hp, level, HP_GROWTH)
  end

  def attack(level)
    calculate_stat(base_attack, level, ATK_GROWTH)
  end

  def defense(level)
    calculate_stat(base_defense, level, DEF_GROWTH)
  end

  def speed(level)
    base_speed + (level - 1) / 2
  end

  def luck(level)
    base_luck + (level - 1) / 3
  end

  def total_power(level)
    hp(level) +
    attack(level) +
    defense(level) +
    speed(level) +
    luck(level)
  end

  private

  def calculate_stat(base, level, growth)
    base + (level - 1) * growth
  end
end
