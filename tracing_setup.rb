if Rails.env.production? || Rails.env.staging?
  Datadog.configure do |c|
    c.service = 'monolith'
    c.version = ENV['VERSION']

    …
    c.use :faraday
    c.use :http
    …
  end
end
