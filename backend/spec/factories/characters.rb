FactoryBot.define do
  factory :character do
    user { nil }
    name { "MyString" }
    level { 1 }
    gold { 1 }
    experience_points { 1 }
    base_hp { 1 }
    base_attack { 1 }
    base_defense { 1 }
    base_speed { 1 }
    base_luck { 1 }
  end
end
