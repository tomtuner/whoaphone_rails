# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Whoaphone::Application.initialize!
ENV['RAILS_ENV'] ||= 'development'