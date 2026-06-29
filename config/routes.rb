# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'country_state_select' do
    # GET is the correct verb for these read-only lookups (and sidesteps CSRF).
    # POST is kept so existing host apps that wired the old routes keep working.
    match 'find_states' => 'cscs#find_states', via: %i[get post]
    match 'find_cities' => 'cscs#find_cities', via: %i[get post]
  end
end
