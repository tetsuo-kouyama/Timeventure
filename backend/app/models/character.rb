class Character < ApplicationRecord
  HP_GROWTH  = 2
  ATK_GROWTH = 1
  DEF_GROWTH = 1

  has_many :adventures, dependent: :destroy
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

  def hp
    calculate_stat(base_hp, level, HP_GROWTH)
  end

  def attack
    calculate_stat(base_attack, level, ATK_GROWTH)
  end

  def defense
    calculate_stat(base_defense, level, DEF_GROWTH)
  end

  # speed は2レベルごとに1上る
  def speed
    base_speed + (level - 1) / 2
  end

  # luck は3レベルごとに1上がる
  def luck
    base_luck + (level - 1) / 3
  end

  def character_total_power
    hp + attack + defense + speed + luck
  end

  private

  def calculate_stat(base, level, growth)
    base + (level - 1) * growth
  end
end
