class HomeController < ApplicationController
  def index
    if current_tutor
      return
    end

    if current_learner
      tutor_app = current_learner.tutor_application
      @tutor_application_status =
        if tutor_app.nil?
          :none
        elsif tutor_app.status == "pending"
          :pending
        end
    end
  end
end
