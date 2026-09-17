class AreaEnemy < ApplicationRecord
  belongs_to :area
  belongs_to :enemy

  validates :level, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :encounter_weight, numericality: { only_integer: true, greater_than: 0 }
  # 同じ area_id + enemy_id の組み合わせを重複登録しない
  validates :enemy_id, uniqueness: { scope: :area_id }
end
