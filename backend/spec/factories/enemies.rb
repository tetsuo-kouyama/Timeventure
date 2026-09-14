FactoryBot.define do
  factory :enemy do
    name { "MyString" }
    base_hp { 1 }
    base_attack { 1 }
    base_defense { 1 }
    base_speed { 1 }
    base_luck { 1 }
    drop_gold { 1 }
    drop_experience_points { 1 }
  end
end
