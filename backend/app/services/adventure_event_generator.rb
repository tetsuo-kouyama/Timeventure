require "digest"

class AdventureEventGenerator
  EVENT_INTERVAL_SECONDS = 300
  TREASURE_GOLD_AMOUNT = 50

  def initialize(adventure, current_time: Time.current)
    @adventure = adventure
    @current_time = current_time
  end

  def call
    generated_events = []

    Adventure.transaction do
      adventure.lock!

      while adventure.next_event_index <= available_event_count
        event_index = adventure.next_event_index
        event = generate_event(event_index)
        generated_events << event

        adventure.next_event_index += 1
      end

      adventure.save!
      character.save!
    end

    generated_events
  end

  private

  attr_reader :adventure, :current_time

  # キャラクターの取得
  def character
    adventure.character
  end

  # ======================================
  # タイマー・時間計算
  # ======================================

  # 最大イベント数を計算する(設定したタイマー / イベント間隔)
  def total_event_count
    adventure.planned_focus_minutes * 60 / EVENT_INTERVAL_SECONDS
  end

  # 現在までの経過秒数を計算する
  def elapsed_seconds
    # 冒険終了後にアクセスしてもend_atまでしか進行しない
    processing_time = [
      current_time,
      adventure.ended_at || current_time
    ].min

    [ (processing_time - adventure.started_at).to_i, 0 ].max
  end

  # 発生するイベント数を計算する
  def available_event_count
    [
      elapsed_seconds / EVENT_INTERVAL_SECONDS,
      total_event_count
    ].min
  end

  # ======================================
  # イベント生成
  # ======================================

  # イベントを一件生成する
  def generate_event(event_index)
    event_type = event_type_for(event_index)

    AdventureEvent.create!(
      adventure: adventure,
      event_index: event_index,
      elapsed_seconds: event_index * EVENT_INTERVAL_SECONDS,
      event_type: event_type,
      payload: payload_for(event_type, event_index)
    )
  end

  # イベントタイプを決める
  def event_type_for(event_index)
    choose_random_event_type(event_index)
  end

  # イベントごとの処理を振り分ける
  def payload_for(event_type, event_index)
    case event_type
    when "battle"
      battle_payload(event_index)
    when "treasure"
      treasure_payload
    else
      {}
    end
  end

  # ======================================
  # ペイロード（各イベントの報酬・ログ）
  # ======================================

  # 宝箱イベント
  def treasure_payload
    gold =  TREASURE_GOLD_AMOUNT
    character.gold += gold

    {
      gold: gold,
      message: "#{gold}Gを手に入れた！"
    }
  end

  # 戦闘イベント
  def battle_payload(event_index)
    # 次のPRで追加
  end

  # ======================================
  # 抽選ロジック
  # ======================================

  # 敵編成の重み付き抽選
  def choose_area_enemy(event_index)
    candidates = adventure.start_area
                          .area_enemies
                          .order(:id)
                          .includes(:enemy)
                          .to_a

    raise "出現可能な敵が設定されていません" if candidates.empty?

    total_weight = candidates.sum(&:encounter_weight)
    random_value = random_for(
      event_index,
      purpose: "enemy"
    ).rand(total_weight)

    candidates.each do |candidate|
      return candidate if random_value < candidate.encounter_weight

      random_value -= candidate.encounter_weight
    end

    raise "敵編成を抽出できませんでした"
  end

  # イベントの重みをハッシュにする
  def event_weights
    {
      "battle" => adventure.start_area.battle_weight,
      "treasure" => adventure.start_area.treasure_weight
    }
  end

  # イベントの重み付き抽選
  def choose_random_event_type(event_index)
    weights = event_weights
    total_weight = weights.values.sum

    random_value = random_for(
      event_index,
      purpose: "event_type"
    ).rand(total_weight)

    weights.each do |event_type, weight|
      return event_type if random_value < weight

      random_value -= weight
    end

    raise "イベントタイプを抽選できませんでした"
  end

  # ======================================
  # 乱数生成器
  # ======================================
  def random_for(event_index, purpose:)
    source = "#{adventure.random_seed}:#{purpose}:#{event_index}"

    event_seed = Digest::SHA256.hexdigest(source).to_i(16) % (2**63)

    Random.new(event_seed)
  end
end
