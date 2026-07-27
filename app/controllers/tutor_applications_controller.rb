class TutorApplicationsController < ApplicationController
  before_action :require_learner

  def new
    tutor_app = current_learner&.tutor_application
    if tutor_app&.status == "pending" || tutor_app&.status == "approved"
      flash[:alert] = "You cannot apply again for now"
      redirect_to root_path and return
    end
  end

  def create
    # build_tutor_application is a method from Rails’ has_one association in the Learner model. It builds a new TutorApplication object for the current_learner
    app = current_learner.build_tutor_application(tutor_application_params)
    app.status = "pending"
    if app.save
      flash[:notice] = "Application Sent!"
    else
      flash[:alert] = "Could Not Apply"
    end
    redirect_to root_path
  end

  private
  def tutor_application_params
    params.require(:tutor_application).permit(:reason)
  end
end
