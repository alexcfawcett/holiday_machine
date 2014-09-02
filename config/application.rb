require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

# TODO temp to assist with incremental move to asset pipeline
# ActiveSupport.on_load(:action_view) do
#   alias_method :without_asset_pipeline_js,  :javascript_include_tag
#   alias_method :without_asset_pipeline_css, :stylesheet_link_tag
#   alias_method :without_asset_pipeline_img, :path_to_image
# end

module HolidayMachine
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    load_paths = [
        'lib',
    ]
    config.autoload_paths += load_paths.map { |path| config.root + path }
    config.time_zone = 'London'
  end
end
