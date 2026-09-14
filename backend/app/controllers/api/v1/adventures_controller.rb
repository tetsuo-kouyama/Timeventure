class Api::V1::AdventuresController < ApplicationController
  def create
    character = Current.user.character
    # 開始エリアを取得（MVPでは固定）
    start_area = Area.find_by!(name: "草原")

    timer_setting = Current.user.timer_setting
    planned_focus_minutes = timer_setting.focus_minutes

    random_seed = SecureRandom.random_number(2**63)

    adventure = character.adventures.create!(
      start_area: start_area,
      planned_focus_minutes: planned_focus_minutes,
      status: :ongoing,
      random_seed: random_seed,
      started_at: Time.current
    )

    render json: {
      adventure: {
        id: adventure.id,
        status: adventure.status,
        started_at: adventure.started_at,
        planned_focus_minutes: adventure.planned_focus_minutes
      }
    }, status: :created
  end
end
