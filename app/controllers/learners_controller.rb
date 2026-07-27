class LearnersController < ApplicationController
  def new
    @learner = Learner.new

    @learner.validate_name_presence = true
  end

  def create
    @learner = Learner.new(learner_params)

    @learner.validate_name_presence = true

    if @learner.save
      redirect_to new_login_path, notice: 'Account Created!'
    else
      @errors = @learner.errors.full_messages
      render :new, status: :unprocessable_content
    end
  end

  private

  def learner_params
    params.require(:learner).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation
    )
  end
end