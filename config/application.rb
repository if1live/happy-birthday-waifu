require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'setty'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HappyBirthdayWaifu
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Seoul'
    config.active_record.default_timezone = 'Seoul'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # https://github.com/rails/web-console/issues/90
    # This will whitelist all IPv4 and IPv6 addresses. Please, only
    # run tests with that configuration, its a huge security hole.
    config.web_console.whitelisted_ips = %w( 0.0.0.0/0 ::/0 ) if Rails.env.development?

    # https://github.com/heroku/rails_12factor#rails-4-serve-static-assets
    # heroku를 버리고 자체 서버 운영하면서 해당 필드가 필요없어졌다.
    # config.serve_static_assets = true

    unless Rails.env.test?
      WebMock.disable!
    end
  end
end
