# frozen_string_literal: true

class ApplicationController < ActionController::API
  def not_found(e)
    render json: { errors: e.message }, status: :not_found
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split('Bearer ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
