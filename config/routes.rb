# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: 'country_state_select' do
    post 'find_states' => 'cscs#find_states'
    post 'find_cities' => 'cscs#find_cities'
  end
end
