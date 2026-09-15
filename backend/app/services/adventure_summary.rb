class AdventureSummary
  def initialize(events)
    @events = events
  end

  def call
    {
      defeated_enemies_count: defeated_enemies_count,
      experience_points: experience_points,
      gold: gold
    }
  end

  private

  attr_reader :events

  # 敵撃破数計算メソッド
  def defeated_enemies_count
    events.count do |event|
      # 戦闘イベントかつ勝利状態であるかを判定
      event.battle? && event.payload["victory"] == true
    end
  end

  # 経験値集計メソッド
  def experience_points
    # 戦闘イベントを抽出し、経験値を合計する
    events.select(&:battle?).sum { |event| event.payload["exp_reward"] }
  end

  # 獲得金額集計メソッド
  def gold
    events.sum do |event|
      if event.battle?
        event.payload["gold_reward"]
      elsif event.treasure?
        event.payload["gold"]
      else
        0  # ゴールドを獲得しないイベントを追加しても 0 として扱える
      end
    end
  end
end
