class Api::V1::TimerSettingsController < ApplicationController
  before_action :set_timer_setting, only: %i[show update]

  def show
    render json: {
      timer_setting: {
        focus_minutes: @timer_setting.focus_minutes,
        break_minutes: @timer_setting.break_minutes
      }
    }, status: :ok
  end

  def update
    if @timer_setting.update(timer_setting_params)
      render json: {
        message: "タイマー設定を更新しました",
        timer_setting: {
          focus_minutes: @timer_setting.focus_minutes,
          break_minutes: @timer_setting.break_minutes
        }
      }, status: :ok
    else
      render json: {
        errors: @timer_setting.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def timer_setting_params
    params.permit(:focus_minutes, :break_minutes)
  end

  def set_timer_setting
    @timer_setting = Current.user.timer_setting
  end
end
