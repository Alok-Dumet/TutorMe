class LoginsController < ApplicationController
  def new; end

  def create
    email    = params[:email].to_s.strip
    password = params[:password].to_s

    if (admin = Admin.find_by('lower(email)=lower(?)', email))&.authenticate(password)
      reset_session
      session[:admin_id] = admin.id
      redirect_to home_path
    elsif (learner = Learner.find_by('lower(email)=lower(?)', email))&.authenticate(password)
      reset_session
      session[:learner_id] = learner.id
      redirect_to home_path
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new, status: :unauthorized
    end
  end

  def delete
    reset_session
    redirect_to new_login_path
  end
end