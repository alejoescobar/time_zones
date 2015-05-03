module Api
  def json_headers
    { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def set_auth_headers(user)
    request.headers["X-AUTH-EMAIL"] = user.email
    request.headers["X-AUTH-TOKEN"] = user.auth_token
  end
  def body
    JSON.parse(response.body)
  end
end

RSpec.configure do |c|
  c.include Api
end
