class Character < ApplicationRecord
  HP_GROWTH  = 2
  ATK_GROWTH = 1
  DEF_GROWTH = 1

  MAX_LEVEL = 10

  # 経験値テーブル（レベル10まで）
  LEVEL_THRESHOLDS = {
    1 => 0,
    2 => 10,
    3 => 30,
    4 => 60,
    5 => 100,
    6 => 150,
    7 => 210,
    8 => 280,
    9 => 360,
    10 => 450
  }.freeze

  has_many :adventures, dependent: :destroy
  belongs_to :user

  validates :name, presence: true
  validates :level, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: MAX_LEVEL }
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

  def total_power
    hp + attack + defense + speed + luck
  end

  # レベルアップ判定
  def update_level
    new_level = LEVEL_THRESHOLDS
      .select { |_level, required_exp| experience_points >= required_exp }
      .keys
      .max

    self.level = new_level
  end

  private

  def calculate_stat(base, level, growth)
    base + (level - 1) * growth
  end
end
