HolidayMachine::Application.routes.draw do
  get "user_settings/change_manager"
  resources :calendar
  get 'absences/holiday_json' => 'absencess#holiday_json'
  resources :absences
  resources :user_days
  resources :settings
  resources :user_settings
  get 'administer/get_team_data' => 'administer#get_team_data'
  get 'administer/create' => 'administer#create'
  resources :administer

  resources :home, :only => :index
  resources :admins, :only => :index
  resources :reports, :only => :index
  root :to => 'absences#index'
  get "info/registration_message"


  devise_for :admin, :users

  devise_scope :user do
    get "sign_in", to: "devise/sessions#new"
    get "register", to: "devise_invitable/registrations#new"
    delete "sign_out", to: "devise/sessions#destroy"
  end
end
