if Rails.application.secrets.sentry_api_key.present?
  Raven.configure do |config|
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
    config.environments = %w[ production ]
    config.dsn = Rails.application.secrets.sentry_api_key
  end
end
