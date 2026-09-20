class Api::V1::TimerSessionsController < ApplicationController
  def create
    current_user = Current.user

    timer_session = TimerSession.start_for!(user: current_user)

    render json: {
      timer_session: {
        id: timer_session.id,
        phase: timer_session.phase,
        status: timer_session.status,
        focus_minutes: timer_session.focus_minutes,
        break_minutes: timer_session.break_minutes,
        phase_started_at: timer_session.phase_started_at,
        phase_ends_at: timer_session.phase_ends_at
      }
    }, status: :created

  rescue TimerSession::AlreadyRunningError => e
    render json: {
      errors: [ e.message ]
    }, status: :conflict
  end

  def complete_focus
    timer_session = Current.user.timer_sessions.find(params[:id])

    generated_events = timer_session.complete_focus!

    summary = AdventureSummary.new(generated_events).call

    adventure = timer_session.adventure

    render json: {
      timer_session: {
        id: timer_session.id,
        phase: timer_session.phase,
        status: timer_session.status,
        focus_minutes: timer_session.focus_minutes,
        break_minutes: timer_session.break_minutes,
        phase_started_at: timer_session.phase_started_at,
        phase_ends_at: timer_session.phase_ends_at
      },
      adventure: {
        id: adventure.id,
        status: adventure.status,
        ended_at: adventure.ended_at,
        generated_events_count: generated_events.size
      },
      summary: summary
    }, status: :ok

  rescue TimerSession::NotRunningFocusError, TimerSession::FocusNotFinishedError => e
    render json: {
      error: e.message
    }, status: :unprocessable_entity
  end
end
