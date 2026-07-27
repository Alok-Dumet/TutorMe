class LearnerSessionsController < ApplicationController
  # Only signed-in learners should see their session lists or cancel bookings
  before_action :require_learner
  before_action :set_booking, only: [:cancel, :confirm_cancel]
  before_action :require_owner!, only: [:cancel, :confirm_cancel]
  before_action :ensure_upcoming!, only: [:cancel, :confirm_cancel]

  def index
    # Upcoming bookings for the current learner
    @upcoming_bookings = SessionAttendee
                           .upcoming_for(current_learner)
                           .includes(tutor_session: [:subject, :tutor])
  end

  def past
    # Past (completed) bookings for the current learner
    @past_bookings = SessionAttendee
                       .past_for(current_learner)
                       .includes(tutor_session: [:subject, :tutor])
  end

  # GET /learner_sessions/:id/cancel
  # Show a confirmation page before cancelling an upcoming booking
  def cancel
    # @booking, @tutor_session already set by before_actions
  end

  # PATCH /learner_sessions/:id/confirm_cancel
  # Handles "Yes" / "No" response from the confirmation page.
  def confirm_cancel
    if params[:decision] == 'yes'
      if @booking.update(cancelled: true)
        redirect_to learner_sessions_path, notice: 'Session cancelled'
      else
        flash.now[:alert] = 'Could not cancel session'
        render :cancel, status: :unprocessable_content
      end
    else
      # Any non-"yes" decision is treated as "No"
      redirect_to learner_sessions_path, notice: 'Cancellation aborted'
    end
  end

  private

  def set_booking
    @booking = SessionAttendee
                 .includes(tutor_session: [:subject, :tutor])
                 .find(params[:id])
    @tutor_session = @booking.tutor_session
  end

  def require_owner!
    return if @booking.learner_id == current_learner.id

    redirect_to learner_sessions_path, alert: 'You are not authorized to cancel that session'
  end

  def ensure_upcoming!
    return if @tutor_session.start_at >= Time.current && !@booking.cancelled?

    redirect_to learner_sessions_path, alert: 'You can only cancel upcoming sessions'
  end
end