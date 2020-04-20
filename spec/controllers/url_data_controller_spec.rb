# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlDataController, type: :controller do
  let(:source_url) { 'https://facebook.com' }

  let(:valid_attributes) do
    { source_url: source_url }
  end

  let(:invalid_attributes) do
    { source_url: 'https://facebookkkkk.com' }
  end

  describe 'GET #show' do
    context 'with valid token' do
      it 'redirects to the original url' do
        url = UrlDatum.create! valid_attributes

        get :show, params: { token: url.token }

        expect(response).to have_http_status(:moved_permanently)
        expect(response).to redirect_to(url.source_url)
      end
    end

    context 'with invalid token' do
      it 'redirects to the homepage' do
        UrlDatum.create! valid_attributes

        get :show, params: { token: '1234567' }

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new shortened url' do
        expect do
          post :create, params: { url_datum: valid_attributes }
        end.to change(UrlDatum, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'does not create a new shortened url' do
        expect do
          post :create, params: { url_datum: invalid_attributes }
        end.to_not change(UrlDatum, :count)
      end
    end

    context 'with valid params and an existing url' do
      it 'does not create a new shortened url' do
        url = UrlDatum.create! valid_attributes
        expect do
          post :create, params: { url_datum: { source_url: url.source_url } }
        end.to_not change(UrlDatum, :count)
      end
    end

    context 'with valid params and an existing url' do
      it 'does not create a new shortened url sanitized_url match is found' do
        url = UrlDatum.create! valid_attributes
        expect do
          post :create, params: { url_datum: { source_url: url.sanitized_url } }
        end.to_not change(UrlDatum, :count)
      end
    end
  end
end
