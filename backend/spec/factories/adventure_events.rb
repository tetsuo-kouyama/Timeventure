FactoryBot.define do
  factory :adventure_event do
    adventure { nil }
    elapsed_seconds { 1 }
    event_index { 1 }
    event_type { 1 }
    payload { "" }
  end
end
