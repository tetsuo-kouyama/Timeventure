class Api::V1::TimerSessionsController < ApplicationController
  before_action :set_timer_session, only: %i[complete_focus interrupt finish_break]

  def create
    current_user = Current.user
    timer_session = TimerSession.start_for!(user: current_user)

    render json: {
      timer_session:  timer_session_json(timer_session)
    }, status: :created

  rescue TimerSession::AlreadyRunningError => e
    render json: {
      errors: [ e.message ]
    }, status: :conflict
  end

  def complete_focus
    generated_events = @timer_session.complete_focus!

    render_adventure_result(@timer_session, generated_events)

  rescue TimerSession::NotRunningFocusError,
         TimerSession::FocusNotFinishedError => e
    render json: {
      error: e.message
    }, status: :unprocessable_entity
  end

  def interrupt
    generated_events = @timer_session.interrupt!

    render_adventure_result(@timer_session, generated_events)

  rescue TimerSession::NotRunningFocusError => e
    render json: {
      error: e.message
    }, status: :unprocessable_entity
  end

  def finish_break
    @timer_session.finish_break!

    render json: {
      timer_session: timer_session_json(@timer_session)
    }, status: :ok

  rescue TimerSession::NotRunningBreakError => e
    render json: {
      error: e.message
    }, status: :unprocessable_entity
  end

  private

  def set_timer_session
    @timer_session = Current.user.timer_sessions.find(params[:id])
  end

  # タイマー状態のレスポンス生成処理
  def timer_session_json(timer_session)
    {
      id: timer_session.id,
      phase: timer_session.phase,
      status: timer_session.status,
      focus_minutes: timer_session.focus_minutes,
      break_minutes: timer_session.break_minutes,
      phase_started_at: timer_session.phase_started_at,
      phase_ends_at: timer_session.phase_ends_at
    }
  end

  # 完了・中断時のレスポンス生成処理
  def render_adventure_result(timer_session, generated_events)
    adventure = timer_session.adventure
    summary = AdventureSummary.new(generated_events).call

    render json: {
      timer_session: timer_session_json(timer_session),
      adventure: {
        id: adventure.id,
        status: adventure.status,
        ended_at: adventure.ended_at,
        generated_events_count: generated_events.size
      },
      summary: summary
    }, status: :ok
  end
end
