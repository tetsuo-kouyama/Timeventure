class Api::V1::AdventuresController < ApplicationController
  before_action :set_adventure, only: %i[complete interrupt]
  before_action :ensure_adventure_ongoing, only: %i[complete interrupt]

  def create
    character = Current.user.character
    adventure = Adventure.start_for!(character: character)

    render json: {
      adventure: {
        id: adventure.id,
        status: adventure.status,
        started_at: adventure.started_at,
        planned_focus_minutes: character.user.timer_setting.focus_minutes
      }
    }, status: :created
  end

  def complete
    scheduled_end_at =
      @adventure.started_at + @adventure.planned_focus_minutes.minutes

    if Time.current < scheduled_end_at
      render json: {
        error: "タイマーはまだ終了していません"
      }, status: :unprocessable_entity
      return
    end

    finish_adventure(ended_at: scheduled_end_at, status: :completed)
  end

  def interrupt
    finish_adventure(ended_at: Time.current, status: :interrupted)
  end

  def current
    character = Current.user.character

    ongoing_adventure =
      character.adventures.find_by(status: :ongoing)

    if ongoing_adventure
      render json: {
        mode: "focus",
        adventure: {
          id: ongoing_adventure.id,
          started_at: ongoing_adventure.started_at,
          planned_focus_minutes: ongoing_adventure.planned_focus_minutes
        }
      }, status: :ok
      return
    end

    completed_adventure =
      character.adventures
               .where(status: :completed)
               .order(ended_at: :desc)
               .first

    if completed_adventure.nil?
      head :no_content
      return
    end

    break_minutes = Current.user.timer_setting.break_minutes

    break_end_at =
      completed_adventure.ended_at + break_minutes.minutes

    if Time.current >= break_end_at
      head :no_content
      return
    end

    render json: {
      mode: "break",
      adventure: {
        id: completed_adventure.id,
        ended_at: completed_adventure.ended_at,
        break_minutes: break_minutes
      }
    }, status: :ok
  end

  private

  # 冒険を取得するコールバック
  def set_adventure
    @adventure = Current.user.character.adventures.find(params[:id])
  end

  # ongoing であることを保証するコールバック
  def ensure_adventure_ongoing
    return if @adventure.ongoing?
    render json: {
      error: "進行中の冒険はありません"
    }, status: :unprocessable_entity
  end

  # 冒険終了後のイベントからサマリーを作成
  def finish_adventure(ended_at:, status:)
    generated_events = @adventure.finish!(ended_at: ended_at, status: status)

    summary = AdventureSummary.new(generated_events).call

    render_adventure_result(generated_events, summary)
  end

  # 完了・中断時のHTTPレスポンス作成処理
  def render_adventure_result(generated_events, summary)
    render json: {
      adventure: {
        id: @adventure.id,
        status: @adventure.status,
        started_at: @adventure.started_at,
        ended_at: @adventure.ended_at,
        generated_events_count: generated_events.size
      },
      summary: summary
    }, status: :ok
  end
end
