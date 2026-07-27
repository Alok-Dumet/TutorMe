Rails.application.routes.draw do
  # Home
  get  "/home", to: "home#index", as: :home
  root to: "home#index"

  # Signup
  resources :learners, only: [ :new, :create ]

  # Login/Logout
  get    "/login",  to: "logins#new",    as: :new_login
  post   "/login",  to: "logins#create", as: :login
  delete "/logout", to: "logins#delete", as: :logout

  # Subjects
resources :subjects, only: [:index, :new, :create, :destroy]

  # Tutors
  resources :tutors, only: [ :index, :show, :edit, :update ]

  # Sessions (tutor sessions for search / booking / attendance)
  resources :sessions, only: [ :new, :create, :show, :update ] do
    collection do
      get :search
      get :results
    end
    member do
      get :confirm
      post :book
    end

    resources :feedbacks, only: [ :new, :create ]
  end

  # Learner's booked sessions (upcoming, past, and cancellation)
  resources :learner_sessions, only: [ :index ] do
    collection do
      get :past
    end

    member do
      get  :cancel
      patch :confirm_cancel
    end
  end

  # Learner feedback on sessions
  resources :feedbacks, only: [ :new, :create ]

  # Tutor feedbacks
  namespace :tutor do
    resources :feedbacks, only: [ :index ]
  end


  # Tutor's booked sessions (upcoming, past, and edit)
  resources :tutor_sessions, only: [:index, :edit, :update] do
    collection do
      get :past
    end
    member do
      get :cancel
      patch :confirm_cancel
    end
  end

  # Tutor Applications
  resources :tutor_applications, only: [ :new, :create ]

# Tutor managing Applications
namespace :admin do
  get "tutor_applications/pending", to: "tutor_applications#pending", as: :tutor_applications_pending

  resources :tutor_applications, only: [] do
    member do
      post :approve
      post :reject
    end
  end
end
end
