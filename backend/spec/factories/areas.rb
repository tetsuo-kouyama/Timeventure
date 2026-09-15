FactoryBot.define do
  factory :area do
    prerequisite_area { nil }
    name { "テストフィールド" }
    area_type { :field }
    battle_weight { 8 }
    treasure_weight { 2 }

    trait :town do
      area_type { :town }
    end
  end
end
