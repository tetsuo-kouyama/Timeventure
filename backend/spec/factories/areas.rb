FactoryBot.define do
  factory :area do
    prerequisite_area { nil }
    name { "MyString" }
    area_type { 1 }
    battle_weight { 1 }
    treasure_weight { 1 }
  end
end
