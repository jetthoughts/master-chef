require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module MasterChef
  class Application < Rails::Application
    VERSION = '0.0.1'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.assets.precompile += %w(ace/* landing.js landing.css)
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    I18n.config.enforce_available_locales = true
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += Dir["#{config.root}/lib/services/*"]

    config.to_prepare do
      Devise::SessionsController.layout 'landing'
      Devise::RegistrationsController.layout 'landing'
      Devise::ConfirmationsController.layout 'landing'
      Devise::UnlocksController.layout 'landing'
      Devise::PasswordsController.layout 'landing'
    end
  end
end
