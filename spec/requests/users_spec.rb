# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  include ApiHelper

  let!(:users) { create_list(:user, 10) }
  let!(:news) { create_list(:news, 10) }
  let(:user_id) { users.last.id }
  let(:username) { users.first.username }

  describe 'GET /users when the request with NO authentication header' do
    before { get '/users' }

    it 'returns status code 401' do
      expect(response).to have_http_status(401)
    end
  end

  describe 'GET /users' do
    before { get '/users', params: {}, headers: authenticated_header(user_id) }

    it 'returns users' do
      expect(json).not_to be_empty
      expect(json.size).to eq(20)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /users' do
    let (:password) { Faker::Internet.password }
    let (:username) { Faker::Internet.user_name }
    let(:valid_attributes) do
      { username: username,
        signature: Faker::Internet.user_name,
        full_name: Faker::Name.name_with_middle,
        password: password,
        password_confirmation: password }
    end

    context 'when the request is valid' do
      before do
        post '/users',
             params: valid_attributes,
             headers: authenticated_header(user_id)
      end

      it 'creates a user' do
        expect(json['username']).to eq(username)
      end

      it 'returns status code created' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/users',
             params: { username: username },
             headers: authenticated_header(user_id)
      end

      it 'returns status code unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("[\"Password can't be blank\",\"Password is too short (minimum is 6 characters)\",\"Signature can't be blank\",\"Full name can't be blank\"]")
      end
    end
  end

  describe 'POST /add_to_selected_news/:selected_news' do
    let(:news_1) { news.first }
    context 'add news to selectd' do
      before do
        post "/add_to_selected_news/#{news_1.id}",
             params: {},
             headers: authenticated_header(user_id)
      end

      it 'creates a user' do
        expect(json['selected_news'][0].to_i).to eq(news_1.id)
      end

      it 'returns status code created' do
        expect(response).to have_http_status(:accepted)
      end
    end
  end

  describe 'POST /add_to_readed_news/:readed_news' do
    let(:news_2) { news[2] }
    context 'add news to readed' do
      before do
        post "/add_to_readed_news/#{news_2.id}",
             params: {},
             headers: authenticated_header(user_id)
      end

      it 'creates a user' do
        expect(json['readed_news'][0].to_i).to eq(news_2.id)
      end

      it 'returns status code created' do
        expect(response).to have_http_status(:accepted)
      end
    end
  end
end
