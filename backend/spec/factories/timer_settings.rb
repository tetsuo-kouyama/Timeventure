FactoryBot.define do
  factory :timer_setting do
    # User作成時に自動生成されるため、
    # Request Specでは基本的にuser.timer_settingを使用する
    focus_minutes { 25 }
    break_minutes { 5 }
  end
end
