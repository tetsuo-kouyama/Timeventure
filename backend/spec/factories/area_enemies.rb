FactoryBot.define do
  factory :area_enemy do
    association :area
    association :enemy

    level { 1 }
    encounter_weight { 100 }
  end
end
