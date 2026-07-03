# frozen_string_literal: true

require 'spec_helper'

describe 'FormBuilder integration (via the dummy Business form)', type: :request do
  describe 'GET /businesses/new' do
    it 'renders a country select and blank state/city text fields' do
      get '/businesses/new'

      expect(response.body).to match(/<select[^>]*id="business_country"/)
      expect(response.body).to include('United States')
      expect(response.body).to match(/<input[^>]*type="text"[^>]*id="business_state"/)
      expect(response.body).to match(/<input[^>]*type="text"[^>]*id="business_city"/)
    end

    it 'stamps the Stimulus target data attributes' do
      get '/businesses/new'

      expect(response.body).to include('data-country-state-select-target="country"')
      expect(response.body).to include('data-country-state-select-target="state"')
      expect(response.body).to include('data-country-state-select-target="city"')
    end
  end

  describe 'GET /businesses/:id/edit' do
    let(:business) { Business.create!(name: 'Golden Gate Cafe', country: 'US', state: 'CA', city: 'San Francisco') }

    it 'renders state and city as populated selects with the saved value selected' do
      get "/businesses/#{business.id}/edit"

      expect(response.body).to match(/<select[^>]*id="business_state"/)
      expect(response.body).to match(/<option selected="selected" value="CA">California<\/option>/)

      expect(response.body).to match(/<select[^>]*id="business_city"/)
      expect(response.body).to match(/<option selected="selected" value="San Francisco">San Francisco<\/option>/)
    end
  end
end
