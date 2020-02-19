# frozen_string_literal: true

class NewsController < ApplicationController
  before_action :authorize_request, except: %i[index show news_of_author unread_user_news]
  before_action :find_news, except: %i[create index news_of_author unread_user_news]
  before_action :find_news_by_author, only: :news_of_author
  before_action :find_unread_user_news, only: :unread_user_news
  before_action :check_user_is_owner_news, only: %i[update destroy]

  def index
    @news = News.all
    render json: @news, status: :ok
  end

  def show
    render json: @news, status: :ok
  end

  def create
    @news = @current_user.news.build(news_params)

    if @news.save
      render json: @news, status: :created
    else
      render json: { errors: @news.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    if @news.update(news_params)
      render json: @news, status: :ok
    else
      render json: { errors: @news.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    if @news.destroy
      render status: :ok
    else
      render json: { errors: @news.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def news_of_author
    render json: @news_by_author, status: :ok
  end

  def unread_user_news
    render json: @unread_user_news, status: :ok
  end

  private

  def check_user_is_owner_news
    render(status: :not_acceptable) && return if @news.user != @current_user
  end

  def find_news
    @news ||= News.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    not_found e
  end

  def find_news_by_author
    @news_by_author ||= User.find_by_signature!(params[:signature]).news
  rescue ActiveRecord::RecordNotFound => e
    not_found e
  end

  def find_unread_user_news
    user_readed_news ||= User.find_by_signature!(params[:signature]).readed_news
    @unread_user_news ||= News.where(['id not in (?)', user_readed_news])
  rescue ActiveRecord::RecordNotFound => e
    not_found e
  end

  def news_params
    params.permit(:header, :announcement, :text)
  end
end
