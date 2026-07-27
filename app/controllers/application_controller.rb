class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Make these helpers available in views
  helper_method :current_learner, :current_admin, :current_tutor

  private

  # Currently signed-in learner (if any)
  def current_learner
    @current_learner ||= Learner.find_by(id: session[:learner_id])
  end

  # Currently signed-in admin (if any)
  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  # Tutor record associated with the current learner (if any)
  def current_tutor
    @current_tutor ||= Tutor.find_by(learner: current_learner) if current_learner
  end

  # Require that a learner be logged in; used by learner-facing controllers
  def require_learner
    return if current_learner

    redirect_to new_login_path
  end

  # Require that an admin be logged in; used by admin-only controllers
  def require_admin
    return if current_admin

    redirect_to new_login_path, alert: 'Please log in as admin'
  end
end