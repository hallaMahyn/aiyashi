class Rack::Attack
  # Limit inquiry form submissions to 5 per minute per IP
  throttle("inquiries/ip", limit: 5, period: 1.minute) do |req|
    req.ip if req.path == "/inquiries" && req.post?
  end
end
