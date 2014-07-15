HolidayMachine::Application.routes.draw do
  get "user_settings/change_manager"
  resources :calendar
  match 'absences/holiday_json' => 'absencess#holiday_json'
  resources :absences
  resources :user_days
  resources :settings
  resources :user_settings
  match 'administer/get_team_data' => 'administer#get_team_data'
  match 'administer/create' => 'administer#create'
  resources :administer
  devise_for :admin
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :home, :only => :index
  resources :admins, :only => :index
  resources :reports, :only => :index
  root :to => 'absences#index'
  get "info/registration_message"
end
