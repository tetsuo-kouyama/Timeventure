FactoryBot.define do
  factory :timer_session do
    association :user

    focus_minutes { 25 }
    break_minutes { 5 }
    phase { :focus }
    status { :ongoing }
    phase_started_at { Time.current }
    phase_ends_at { phase_started_at + focus_minutes.minutes }

    trait :completed do
      status { :completed }
    end

    trait :interrupted do
      status { :interrupted }
    end

    # 休憩タイマー
    trait :break do
      phase { :break }
      phase_ends_at { phase_started_at + break_minutes.minutes }
    end

    # 期限切れのタイマー
    trait :expired do
      phase_started_at { (focus_minutes + break_minutes + 5).minutes.ago }
    end

    # 終了予定時刻を過ぎた集中タイマー
    trait :focus_expired do
      phase { :focus }
      phase_started_at { (focus_minutes + 1).minutes.ago }
      phase_ends_at { phase_started_at + focus_minutes.minutes }
    end

    # 終了予定時刻を過ぎた休憩タイマー
    trait :break_expired do
      phase { :break }
      phase_started_at { (break_minutes + 5).minutes.ago }
      phase_ends_at { phase_started_at + break_minutes.minutes }
    end

    # 関連する冒険を作成
    trait :with_adventure do
      after(:create) do |timer_session|
        start_area = Area.find_by!(name: "草原")
        create(
          :adventure,
          timer_session: timer_session,
          character: timer_session.user.character,
          start_area: start_area,
          started_at: timer_session.phase_started_at,
          planned_focus_minutes: timer_session.focus_minutes
        )
      end
    end
  end
end
