# Settings specified here will take precedence over those in config/environment.rb
# rails.application.routes.default_url_options[:host]= 'localhost:3000'
#config.action_controller.default_url_options = { :host => 'wolf7.com'}
# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.perform_deliveries = true
config.action_mailer.delivery_method = :smtp
config.action_mailer.raise_delivery_errors = true

#config.action_mailer.smtp_settings = {
#  :enable_starttls_auto => true,
#  :address        => 'smtp.gmail.com',
#  :port           => 587,
#  :domain         => 'nrdpfc.ca',
#  :authentication => :login,
#  :content_type   => "text/html",
#  :user_name      => 'drburrett@gmail.com',
#  :password       => 'bagend2683'
#}