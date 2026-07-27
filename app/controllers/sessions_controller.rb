class SessionsController < ApplicationController
  before_action :require_learner
  before_action :current_session, only: [:show, :update, :confirm, :book]
  before_action :require_authorization, only: [:show, :update]
  before_action :require_tutor, only: [:new, :create]
  before_action :load_subjects, only: [:new, :create]

  def update
    if params[:session_attendee][:attended].blank?
      flash.now[:alert] = "No attendance option selected."
      render :show, status: :unprocessable_content
      return
    end

    if @tutor_session.start_at > Time.current
      flash.now[:alert] = "Cannot mark attendance for sessions that have not yet occurred."
      render :show, status: :unprocessable_content
      return
    end

    learner = Learner.find(params[:session_attendee][:learner_id])
    attendee = SessionAttendee.find_or_initialize_by(
      tutor_session: @tutor_session,
      learner: learner
    )
    attendee.attended = (params[:session_attendee][:attended] == "true")

    if attendee.save
      message = attendee.attended ?
        "Learner marked as present" : "Learner marked as absent"
      redirect_to session_path(@tutor_session), notice: message
    else
      flash.now[:alert] = "Failed to save attendance."
      render :show, status: :unprocessable_content
    end
  end

  def search
  end

  def results
    subject_name = params[:subject]

    # Require subject to be selected
    if subject_name.blank?
      flash.now[:alert] = "Please select a subject"
      @sessions = []
      return
    end

    @subject = Subject.active.find_by("LOWER(name) = ?", subject_name.downcase)

    # Subject must exist
    if @subject.nil?
      flash.now[:alert] = "No such subject"
      @sessions = []
      return
    end

    # Base scope: this subject, future sessions, valid statuses
    @sessions = TutorSession.where(subject_id: @subject.id)
                            .where("start_at >= ?", Time.current)
                            .where(status: ["Scheduled", "scheduled"])

    # Optional time filtering
    if params[:start_at].present?
      begin
        start_time = Time.zone.parse(params[:start_at])
        @sessions = @sessions.where("start_at >= ?", start_time) if start_time
      rescue ArgumentError, TypeError
        # ignore bad time input, keep base scope
      end
    end

    if params[:end_at].present?
      begin
        end_time = Time.zone.parse(params[:end_at])
        @sessions = @sessions.where("end_at <= ?", end_time) if end_time
      rescue ArgumentError, TypeError
        # ignore bad time input, keep base scope
      end
    end

    @sessions = @sessions.order(:start_at)
  end

  def confirm
  end

  def book
    # Makes sure tutor can't book their own tutor session
    current_tutor = Tutor.find_by(learner: current_learner)
    if current_tutor && @tutor_session.tutor == current_tutor
      redirect_to confirm_session_path(@tutor_session), alert: "You cannot book your own session"
      return
    end

    # Double booking: only consider non-cancelled bookings
    if SessionAttendee.exists?(tutor_session: @tutor_session,
                               learner: current_learner,
                               cancelled: false)
      redirect_to confirm_session_path(@tutor_session), alert: "You are already booked for that session"
      return
    end

    @attendee = SessionAttendee.new(
      tutor_session: @tutor_session,
      learner: current_learner
    )

    if @attendee.save
      redirect_to learner_sessions_path, notice: "Booking confirmed"
    else
      error_message = @attendee.errors.full_messages.first
      redirect_to confirm_session_path(@tutor_session), alert: error_message
    end
  end

  def new
    @tutor_session = TutorSession.new
  end

  def create
    @tutor_session = TutorSession.new
    @tutor_session.tutor  = current_tutor
    @tutor_session.status = "scheduled"

    if params[:tutor_session][:subject_id].present?
      @tutor_session.subject = Subject.find(params[:tutor_session][:subject_id])

    elsif params[:tutor_session][:subject].present?
      subject_name = params[:tutor_session][:subject]
      subject = Subject.find_or_create_by(name: subject_name) do |s|
        s.code = subject_name.upcase.gsub(/[^A-Z]/, "")[0..5] || "SUBJ"
      end
      @tutor_session.subject = subject
    end

    @tutor_session.capacity = params[:tutor_session][:capacity]
    @tutor_session.meeting_link = params[:tutor_session][:meeting_link]

    begin
      start_at = params[:tutor_session][:start_at]
      if start_at.present?
        parsed_start = Time.zone.parse(start_at)
        @tutor_session.start_at = parsed_start

        hours = params[:duration_hours].to_i
        minutes = params[:duration_minutes].to_i
        duration_seconds = hours.hours + minutes.minutes

        if duration_seconds > 0
          @tutor_session.end_at = parsed_start + duration_seconds
        else
          @tutor_session.end_at = parsed_start 
        end
      end
    rescue ArgumentError, TypeError
    end

    if @tutor_session.save
      redirect_to tutor_sessions_path, notice: "Session successfully created"
    else
      @errors = @tutor_session.errors.full_messages
      render :new, status: :unprocessable_content
    end
  end

  def show
    @tutor_session = TutorSession.find(params[:id])

    attendee = SessionAttendee.find_by(
      tutor_session: @tutor_session,
      learner: current_learner
    )

    if attendee && attendee.attended == false
      flash.now[:alert] = "You were not marked present for this session"
    end
  end

  private

  def current_session
    @tutor_session = TutorSession.find(params[:id])
  end

  def require_authorization
    current_tutor = Tutor.find_by(learner: current_learner)
    is_tutor = current_tutor && @tutor_session.tutor == current_tutor

    is_attendee = SessionAttendee.exists?(tutor_session: @tutor_session, learner: current_learner)

    return if is_tutor || is_attendee

    redirect_to new_login_path
  end

  def tutor_session_params
    params.require(:tutor_session).permit(
      :start_at,
      :capacity,
      :meeting_link
    )
  end

  def require_tutor
    return if current_tutor

    redirect_to new_login_path, alert: "You must be logged in as a tutor"
  end

  def load_subjects
    @subjects = Subject.active.order(:name)
  end
end