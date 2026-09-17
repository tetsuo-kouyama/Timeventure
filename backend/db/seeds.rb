# ====================
# 1. エリア定義
# ====================

areas_data = [
  {
    name: "草原",
    area_type: :field,
    prerequisite_name: nil, # 前提エリアなし
    battle_weight: 8,
    treasure_weight: 2
  }
]

areas_data.each do |data|
  # 前提ダンジョンの名前が指定されている場合、名前からオブジェクトを取得
  prerequisite_area =
    Area.find_by!(name: data[:prerequisite_name]) if data[:prerequisite_name]

  # name をキーにしてデータを取得または作成
  area = Area.find_or_initialize_by(name: data[:name])

  area.update!(
    area_type: data[:area_type],
    prerequisite_area: prerequisite_area,
    battle_weight: data[:battle_weight],
    treasure_weight: data[:treasure_weight]
  )
end
puts "🏰 エリアの seed データの読み込みに成功しました! (Total: #{Area.count})"

# ====================
# 2. 敵データ定義
# ====================

enemies_data = [
  {
    name: "スライム",
    base_hp: 10,
    base_attack: 3,
    base_defense: 1,
    base_speed: 2,
    base_luck: 1,
    drop_gold: 5,
    drop_experience_points: 3
  },
  {
    name: "ゴブリン",
    base_hp: 20,
    base_attack: 6,
    base_defense: 3,
    base_speed: 4,
    base_luck: 2,
    drop_gold: 10,
    drop_experience_points: 8
  }
]

enemies_data.each do |data|
  enemy = Enemy.find_or_initialize_by(name: data[:name])

  enemy.update!(
    base_hp: data[:base_hp],
    base_attack: data[:base_attack],
    base_defense: data[:base_defense],
    base_speed: data[:base_speed],
    base_luck: data[:base_luck],
    drop_gold: data[:drop_gold],
    drop_experience_points: data[:drop_experience_points]
  )
end
puts "👾 モンスターの seed データの読み込みに成功しました! (Total: #{Enemy.count})"

# ====================
# 3. 出現敵定義
# ====================

area_enemies_data = [
  {
    area_name: "草原",
    enemy_name: "スライム",
    level: 1,
    encounter_weight: 80
  },
  {
    area_name: "草原",
    enemy_name: "ゴブリン",
    level: 2,
    encounter_weight: 20
  }
]

area_enemies_data.each do |data|
  area = Area.find_by!(name: data[:area_name])
  enemy = Enemy.find_by!(name: data[:enemy_name])

  area_enemy = AreaEnemy.find_or_initialize_by(
    area: area,
    enemy: enemy
  )

  area_enemy.update!(
    level: data[:level],
    encounter_weight: data[:encounter_weight]
  )
end
puts "⚔️ エリアに出現する敵の seed データの読み込みに成功しました！"
