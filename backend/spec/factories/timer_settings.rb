FactoryBot.define do
  factory :timer_setting do
    user { nil }
    focus_minutes { 1 }
    break_minutes { 1 }
  end
end
