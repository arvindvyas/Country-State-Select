# frozen_string_literal: true

require 'spec_helper'

describe 'CountryStateSelect lookup endpoints', type: :request do
  describe 'GET /find_states' do
    it 'returns raw [code, name] pairs for the given country' do
      get '/find_states', params: { country_id: 'US' }, as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body).to include(%w[CA California])
    end

    it 'returns an empty array for a country with no states' do
      get '/find_states', params: { country_id: 'MF' }, as: :json

      expect(JSON.parse(response.body)).to eq([])
    end

    it 'sets Cache-Control based on the configured cache_duration' do
      CountryStateSelect.configure { |c| c.cache_duration = 3600 }

      get '/find_states', params: { country_id: 'US' }, as: :json

      expect(response.headers['Cache-Control']).to include('max-age=3600')
      expect(response.headers['ETag']).to be_present
    end

    it 'does not mark the response public when cache_duration is disabled' do
      CountryStateSelect.configure { |c| c.cache_duration = nil }

      get '/find_states', params: { country_id: 'US' }, as: :json

      expect(response.headers['Cache-Control']).not_to include('public')
    end

    it 'returns 304 on a conditional request with a matching ETag' do
      get '/find_states', params: { country_id: 'US' }, as: :json
      etag = response.headers['ETag']

      get '/find_states', params: { country_id: 'US' }, headers: { 'If-None-Match' => etag }, as: :json

      expect(response).to have_http_status(:not_modified)
    end

    it 'applies only/except/priority filtering configured on the data source' do
      CountryStateSelect.configure { |c| c.priority_countries = [] }

      get '/find_states', params: { country_id: 'US' }, as: :json
      codes = JSON.parse(response.body).map(&:first)

      expect(codes).to include('CA', 'NY')
      expect(codes).not_to include('COUNTRY_ISO_CODE')
    end
  end

  describe 'GET /find_cities' do
    it 'returns city names for the given state and country' do
      get '/find_cities', params: { state_id: 'mp', country_id: 'in' }, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an(Array)
    end

    it 'returns an empty array when state_id is blank' do
      get '/find_cities', params: { state_id: '', country_id: 'us' }, as: :json

      expect(JSON.parse(response.body)).to eq([])
    end
  end
end
