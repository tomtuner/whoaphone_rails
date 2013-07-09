require 'api_constraints'

Whoaphone::Application.routes.draw do
  
	namespace :api, :defaults => {:format => 'json'} do
		scope :module => :v1, :constraints => ApiConstraints.new(:version => 1, :default => true) do
      resources :devices
      
      # resources :events
      # resources :scans
      # resources :customers
      # resources :departments
      # resources :department_validation
		end
	end
  
  #get "devices/index"
  resources :devices
 
   # resources :events
   # resources :scans
   # resources :customers
   # resources :departments
   # resources :department_validation
	
 	root :to => 'devices#index', :as =>'devices'
 
end
