# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'News API', type: :request do
  include ApiHelper

  let!(:news) { create_list(:news, 10) }
  let(:user_id) { news.last.user.id }

  describe 'GET /news when the request with NO authentication header' do
    before { get '/news' }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /news' do
    before { get '/news', params: {}, headers: authenticated_header(user_id) }

    it 'returns news' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /news/:id with NO authentication header' do
    let (:news_0) { create(:news) }
    let(:news_id) { 9999 }

    context 'when the record exists' do
      before do
        get "/news/#{news_0.id}"
      end

      it 'returns one news' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(news_0.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before do
        get "/news/#{news_id}"
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/"Couldn't find News with 'id'=9999\"/)
      end
    end
  end

  describe 'POST /news' do
    let (:user) { create(:user) }
    let (:header) { Faker::Lorem.sentence }
    let(:valid_attributes) do
      { user: user,
        header: header,
        announcement: Faker::Lorem.sentence,
        text: Faker::Lorem.paragraph }
    end

    context 'when the request is valid' do
      before do
        post '/news',
             params: valid_attributes,
             headers: authenticated_header(user_id)
      end

      it 'creates a news' do
        expect(json['header']).to eq(header)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/news',
             params: { header: header },
             headers: authenticated_header(user_id)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("[\"Announcement can't be blank\",\"Text can't be blank\",\"User news is invalid\"]")
      end
    end
  end

  describe 'PUT /news/:id' do
    let(:valid_attributes) { { header: Faker::Lorem.sentence } }
    let (:news_1) { create(:news) }

    context 'when user is owner of news' do
      before do
        put "/news/#{news_1.id}",
            params: valid_attributes,
            headers: authenticated_header(news_1.user.id)
      end

      it 'updates the record' do
        expect(json['header']).to eq(valid_attributes[:header])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user not owner of news' do
      before do
        put "/news/#{news[3].id}",
            params: valid_attributes,
            headers: authenticated_header(news[4].user.id)
      end

      it 'returns status code 406' do
        expect(response).to have_http_status(406)
      end
    end
  end

  describe 'DELETE /news/:id' do
    let (:news_2) { create(:news) }
    let (:news_3) { create(:news) }

    context 'when user is owner of news' do
      before do
        delete "/news/#{news_2.id}",
               params: {},
               headers: authenticated_header(news_2.user.id)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user not owner of news' do
      before do
        put "/news/#{news_3.id}",
            params: {},
            headers: authenticated_header(news_2.user.id)
      end

      it 'returns status code 406' do
        expect(response).to have_http_status(406)
      end
    end
  end

  describe 'GET /:signature/news' do
    let (:news_4) { create(:news) }

    context 'when user have news' do
      before do
        get "/#{news_4.user.signature}/news"
      end

      it 'get user news' do
        expect(json[0]['header']).to eq(news_4.header)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /:signature/unread_news' do
    let (:user_1) { create(:user) }

    context 'make one news as readed' do
      before do
        post "/add_to_readed_news/#{news.last.id}",
             params: {},
             headers: authenticated_header(user_1.id)
      end
      before do
        get "/#{user_1.signature}/unread_news"
      end

      it 'check unreaded news' do
        expect(json).not_to include(news.last.attributes)
        expect(json.count).to eq(9)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
