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
end
