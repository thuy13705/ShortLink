class Rack::Attack
  # Throttle requests per IP: 60 req/min
  throttle('req/ip', limit: 60, period: 1.minute) do |req|
    req.ip
  end

  self.throttled_responder = lambda do |env|
    [429, {'Content-Type' => 'application/json'}, [{ error: 'Throttle limit reached' }.to_json]]
  end
end
