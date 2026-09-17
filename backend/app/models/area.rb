class Area < ApplicationRecord
  has_many :area_enemies, dependent: :destroy
  has_many :enemies, through: :area_enemies
  has_many :adventures, foreign_key: :start_area_id, dependent: :restrict_with_error

  # 前提エリア
  has_many :next_areas, class_name: "Area", foreign_key: "prerequisite_area_id", dependent: :nullify
  belongs_to :prerequisite_area, class_name: "Area", optional: true

  enum :area_type, {
    field: 0,
    town: 1
  }

  validates :name, presence: true
  validates :area_type, presence: true
  validates :battle_weight, :treasure_weight, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :event_weights_must_have_positive_total
  validate :cannot_be_own_prerequisite

  private

  # 合計0によるゼロ除算エラーチェック
  def event_weights_must_have_positive_total
    # 数値バリデーションを通過している前提ならそのまま計算可能
    return if battle_weight.nil? || treasure_weight.nil?

    total = battle_weight + treasure_weight

    if total.zero?
      errors.add(:base, "イベント重みの合計は1以上である必要があります")
    end
  end

  # 自分自身を前提エリアに設定できないようにするチェック
  def cannot_be_own_prerequisite
    if prerequisite_area_id.present? && prerequisite_area_id == id
      errors.add(:prerequisite_area_id, "に自分自身を設定することはできません")
    end
  end
end
