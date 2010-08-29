@app_name = Rails::Application.subclasses[0].name.to_s.split("::")[0]
#remove prototype
run "rm public/javascripts/controls.js"
run "rm public/javascripts/dragdrop.js"
run "rm public/javascripts/effects.js"
run "rm public/javascripts/prototype.js"

#add jQuery files
run "cp -r ../rails3setup/install/. ."

gem 'rails3-generators'

#rspec/cucumber stuff

gem "rspec-rails", ">= 2.0.0.beta.11"
gem 'capybara'
gem 'database_cleaner'
gem 'cucumber-rails'
gem 'cucumber'
gem 'spork'
gem 'launchy'    # So you can do Then show me the page
gem 'prawn'

#add jQuery hooks
run "rm config/application.rb"
file 'config/application.rb', <<-ERB
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module #{@app_name}
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(\#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w(jquery jquery-ui rails application)
    config.action_view.stylesheet_expansions[:defaults] = %w(jquery-ui main)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end
ERB

run "rm app/views/layouts/application.html.erb"
file 'app/views/layouts/application.html.erb', <<-ERB
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
  <title>#{@app_name.titleize}</title>
  <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
  <%= javascript_include_tag :defaults %>
  <%= stylesheet_link_tag :defaults %>
</head>
<body>
  <%= yield %>
</body>
</html>
ERB

run "touch public/stylesheets/main.css"

#final tasks
generate 'cucumber:install','--rspec', '--capybara'