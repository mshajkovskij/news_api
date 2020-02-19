# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, param: :username, only: %i[index create]
  resources :news, except: %i[new edit]

  post '/auth/login', to: 'authentication#login'

  get '/:signature/news', constraints: { signature: %r{[^/]+} }, to: 'news#news_of_author'
  get '/:signature/unread_news', constraints: { signature: %r{[^/]+} }, to: 'news#unread_user_news'

  post '/add_to_selected_news/:selected_news', to: 'users#add_to_selected'
  post '/add_to_readed_news/:readed_news', to: 'users#add_to_readed'
end
