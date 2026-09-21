FactoryBot.define do
  factory :timer_session do
    user { nil }
    focus_minutes { 1 }
    break_minutes { 1 }
    phase { 1 }
    status { 1 }
    phase_started_at { "2026-09-20 15:46:01" }
    phase_ends_at { "2026-09-20 15:46:01" }
  end
end
