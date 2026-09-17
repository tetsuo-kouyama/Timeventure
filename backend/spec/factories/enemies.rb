FactoryBot.define do
  factory :enemy do
    name { "スライム" }
    base_hp { 10 }
    base_attack { 3 }
    base_defense { 1 }
    base_speed { 2 }
    base_luck { 1 }
    drop_gold { 5 }
    drop_experience_points { 3 }
  end
end
