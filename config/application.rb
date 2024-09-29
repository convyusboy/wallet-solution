require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WalletSolution
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.active_record.encryption.primary_key = "Hims8lYaA6N4ASAu7g3Ool9IRL3zfB3H"
    config.active_record.encryption.deterministic_key = "kf4AWj1gKqR3B2ghEGYUWak9APURft0N"
    config.active_record.encryption.key_derivation_salt = "qhg8mYCBp7LH6q2GnwmTjVlLaL79G3Gm"
    config.credentials.content_path = "config/credentials/local.yml.enc"
  end
end
