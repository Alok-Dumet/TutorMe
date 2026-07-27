class Admin::TutorApplicationsController < ApplicationController
  before_action :require_admin

  def pending
    @tutor_applications = TutorApplication.where(status: "pending").includes(:learner)
  end

  def approve
    application = TutorApplication.find_by(id: params[:id])

    if application.nil?
      redirect_to admin_tutor_applications_pending_path, alert: "Invalid Learner was passed"
      return
    end

    if Tutor.exists?(learner: application.learner)
      redirect_to admin_tutor_applications_pending_path, alert: "Learner is already Tutor"
      return
    end

    Tutor.create!(learner: application.learner)
    application.update!(status: "approved")
    redirect_to admin_tutor_applications_pending_path, notice: "Application approved successfully"
  end

  def reject
    application = TutorApplication.find_by(id: params[:id])

    if application.nil?
      redirect_to admin_tutor_applications_pending_path, alert: "Invalid Learner was passed"
      return
    end

    if Tutor.exists?(learner: application.learner)
      redirect_to admin_tutor_applications_pending_path, alert: "Learner is already a Tutor"
      return
    end

    application.destroy
    redirect_to admin_tutor_applications_pending_path, alert: "Application rejected"
  end
end
