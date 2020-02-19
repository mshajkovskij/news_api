# frozen_string_literal: true

class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = 24.hours.since
      render json: { token: token, exp: time.strftime('%m-%d-%Y %H:%M %z'),
                     username: @user.username }, status: :ok
    else
      render status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
