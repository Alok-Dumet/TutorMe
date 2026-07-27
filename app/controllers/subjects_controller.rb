class SubjectsController < ApplicationController
  before_action :require_admin
  before_action :set_subject, only: [:destroy]

  def index
    @subjects = Subject.active.order(:name)
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    if @subject.save
      redirect_to new_subject_path, notice: "Subject created: #{@subject.name} (#{@subject.code})"
    else
      flash.now[:alert] = 'Could not create subject'
      render :new, status: :unprocessable_content # 422
    end
  end

  def destroy
    if @subject.update(archived: true)
      redirect_to subjects_path, notice: "Subject was successfully archived."
    else
      redirect_to subjects_path, alert: "Could not archive subject."
    end
  end

  private

  def set_subject
    @subject = Subject.find(params[:id])
  end

  def subject_params
    params.require(:subject).permit(:name, :code, :description)
  end
end