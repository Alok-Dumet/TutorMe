class TutorsController < ApplicationController
  before_action :set_tutor, only: [:show, :edit, :update]
  before_action :require_learner, only: [:edit, :update]
  before_action :check_authorization, only: [:edit, :update]

  def index
    base_scope = Tutor.includes(:learner, :feedbacks)

    if params[:subject].present?
      subject = Subject.find_by(name: params[:subject])
      if subject
        @tutors = base_scope.joins(:subjects).where(subjects: { id: subject.id })
      else
        flash.now[:alert] = "No subject to filter"
        @tutors = []
      end
    else
      @tutors = base_scope.all
    end
  end

  def show
  end

  def edit
  end

  def update
    if @tutor.bio == tutor_params[:bio]
      redirect_to edit_tutor_path(@tutor), notice: "No changes made"
      return
    end

    if @tutor.update(tutor_params)
      redirect_to edit_tutor_path(@tutor), notice: "Changes saved"
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_tutor
    @tutor = Tutor.find(params[:id])
  end

  def check_authorization
    unless current_tutor && @tutor == current_tutor
      redirect_to home_path, alert: "You are not authorized to edit this profile"
    end
  end

  def tutor_params
    params.require(:tutor).permit(:bio)
  end
end