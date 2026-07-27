class Tutor::FeedbacksController < ApplicationController
  before_action :require_learner

  def index
    tutor = current_tutor
    unless tutor
      redirect_to new_login_path
      return
    end

    # Access control: prevent accessing another tutor's feedback via param
    if params[:tutor_id].present? && params[:tutor_id].to_i != tutor.id
      flash[:alert] = 'Access denied'
      redirect_to tutor_feedbacks_path
      return
    end

    @subject_filter = params[:subject].presence

    # Base scope: all feedback for this tutor
    scoped = Feedback.where(tutor: tutor).includes(tutor_session: :subject, learner: {})

    if @subject_filter
      subject = Subject.find_by(name: @subject_filter)
      scoped = scoped.joins(:tutor_session).where(tutor_sessions: { subject_id: subject.id }) if subject
    end

    # Order newest first
    scoped = scoped.order(created_at: :desc)

    # Simple pagination (10 per page)
    @page      = (params[:page] || 1).to_i
    @per_page  = 10
    @total     = scoped.count
    @total_pages = (@total.to_f / @per_page).ceil
    @feedbacks = scoped.limit(@per_page).offset((@page - 1) * @per_page)

    # Summary stats on filtered set
    @total_reviews = scoped.count
    avg = scoped.average(:rating)
    @average_rating = avg ? avg.round(1) : 0

    # Subjects for filter dropdown
    @subjects = Subject.joins("INNER JOIN tutor_sessions ON tutor_sessions.subject_id = subjects.id")
                       .joins("INNER JOIN feedbacks ON feedbacks.tutor_session_id = tutor_sessions.id")
                       .where(feedbacks: { tutor_id: tutor.id })
                       .distinct
                       .order(:name)
  end
end
