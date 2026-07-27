class TutorSessionsController < ApplicationController
  # Only signed-in tutors should see their session lists
  before_action :require_tutor
  before_action :set_session, only: [:cancel, :confirm_cancel, :edit, :update]
  before_action :authorize_tutor, only: [:edit, :update]

  def index
    # Upcoming sessions for the current tutor
    @upcoming_sessions = TutorSession
      .where(tutor_id: current_tutor.id, status: ['scheduled', 'cancelled'])
      .where("start_at >= ?", Time.current)
      .includes(:subject)
      .order(:start_at)
  end

  def past
    # Past sessions for the current tutor
    @past_sessions = TutorSession
      .where(tutor_id: current_tutor.id, status: 'completed')
      .or(
        TutorSession.where(tutor_id: current_tutor.id)
          .where("end_at < ?", Time.current)
      )
      .includes(:subject)
      .order(start_at: :desc)
  end

  def edit
    if @session.start_at < Time.current || @session.status != 'scheduled'
      redirect_to tutor_sessions_path, alert: "You can only edit upcoming sessions"
      return
    end
  end

  def update
    if @session.update(tutor_session_params)
      redirect_to tutor_sessions_path , notice: 'Session updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    if @session.tutor != current_tutor
      redirect_to tutor_sessions_path, alert: "You are not authorized to cancel the session"
      return
    end

    if @session.start_at < Time.current || @session.status != 'scheduled'
      redirect_to tutor_sessions_path, alert: "You can only cancel upcoming sessions"
      return
    end
  end

  # PATCH /tutor_sessions/:id/confirm_cancel
  def confirm_cancel
    if @session.tutor != current_tutor
      redirect_to tutor_sessions_path, alert: "You are not authorized to cancel the session"
      return
    end

    if @session.start_at < Time.current || @session.status != 'scheduled'
      redirect_to tutor_sessions_path, alert: "You can only cancel upcoming sessions"
      return
    end

    @session.update!(status: 'cancelled')
    redirect_to tutor_sessions_path, notice: "Session cancelled"
  end

  private

  def set_session
    @session = TutorSession.find(params[:id])
  end

  def require_tutor
    redirect_to(new_login_path) and return unless current_tutor
  end

  def tutor_session_params
    params.require(:tutor_session).permit(:meeting_link)
  end

  def authorize_tutor
    unless @session.tutor == current_tutor
      redirect_to tutor_sessions_path, alert: "You cannot edit another tutor's session"
    end
  end
end
