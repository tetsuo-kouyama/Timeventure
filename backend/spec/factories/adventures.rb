FactoryBot.define do
  factory :adventure do
    association :character
    association :start_area, factory: :area  # start_area には area を使う

    planned_focus_minutes { 25 }
    status { :ongoing }
    random_seed { SecureRandom.random_number(2**63) }
    started_at { Time.current }
    ended_at { nil }
  end

  # 進行中
  trait :ongoing do
    status { :ongoing }
    ended_at { nil }
  end

  # 完了
  trait :completed do
    status { :completed }
    ended_at { Time.current }
  end

  # 中断
  trait :interrupted do
    status { :interrupted }
    ended_at { Time.current }
  end
end
