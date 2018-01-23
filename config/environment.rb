# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Prelaunchr::Application.initialize!

Rails.logger = Logger.new(STDOUT)


ActionMailer::Base.smtp_settings = {
  user_name: ENV["SENDGRID_USERNAME"],
  password:  ENV["SENDGRID_PASSWORD"],
  :domain => 'yourdomain.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}


