# frozen_string_literal: true

require 'jwt'

module ApiHelper
  def authenticated_header(user_id)
    token = JsonWebToken.encode(user_id: user_id)
    { 'Authorization': "Bearer #{token}" }
  end

  def app
    Rails.application
  end
end
