if Settings.airbrake_key
  Airbrake.configure do |config|
    config.api_key = Settings.airbrake_key
  end
end
