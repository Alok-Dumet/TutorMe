class FeedbacksController < ApplicationController
  before_action :require_learner
  before_action :set_tutor_session
  before_action :ensure_attended

  def new
    # Prevent duplicate feedback from the same learner for this session
    if Feedback.exists?(tutor_session: @tutor_session, learner: current_learner)
      redirect_to session_path(@tutor_session),
                  alert: "You have already submitted feedback for this session"
    else
      @feedback = Feedback.new
    end
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.tutor_session = @tutor_session
    @feedback.learner       = current_learner
    @feedback.tutor         = @tutor_session.tutor   # 👈 NEW: satisfy "Tutor must exist"

    if @feedback.save
      # mark that this learner has submitted feedback for this session
      attendee = SessionAttendee.find_by(
        tutor_session: @tutor_session,
        learner:       current_learner
      )
      attendee&.update!(feedback_submitted: true)

    redirect_to learner_sessions_path,
                notice: "Thank you for your feedback!"
  else
    flash.now[:alert] = @feedback.errors.full_messages.join(", ")
    render :new, status: :unprocessable_entity
  end
end

  private

  def set_tutor_session
    # Because we nested feedback under sessions:
    # /sessions/:session_id/feedbacks/new
    @tutor_session = TutorSession.find(params[:session_id])
  end

  def ensure_attended
    attendee = SessionAttendee.find_by(
      tutor_session: @tutor_session,
      learner:       current_learner
    )

    # If the learner was not marked present, block access
    if attendee.nil? || attendee.attended != true
      flash[:alert] = "You were not marked present for this session"
      redirect_to session_path(@tutor_session)
    end
  end

  def feedback_params
    params.require(:feedback).permit(:rating, :comment)
  end
end
