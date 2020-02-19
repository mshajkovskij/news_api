# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def add_to_selected
    param = params[:selected_news]

    if @current_user.selected_news.include? param || param.blank?
      render(status: :not_acceptable) && return
    end

    add_to_statistic params
  end

  def add_to_readed
    param = params[:readed_news]

    if @current_user.readed_news.include? param || param.blank?
      render(status: :not_acceptable) && return
    end

    add_to_statistic params
  end

  private

  def add_to_statistic(params)
    if params[:readed_news]
      @current_user.readed_news << params[:readed_news]
    elsif params[:selected_news]
      @current_user.selected_news << params[:selected_news]
    end

    if @current_user.save
      render json: @current_user, status: :accepted
    else
      render json: { errors: @current_user.errors.full_news },
             status: :unprocessable_entity
    end
  end

  def user_params
    params.permit(
      :username,
      :signature,
      :full_name,
      :password,
      :password_confirmation,
      :selected_news,
      :readed_news
    )
  end
end
