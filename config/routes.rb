Rails.application.routes.draw do
  post 'find_states' => 'country_state_select/cscs#find_states'
  get 'find_states' => 'country_state_select/cscs#find_states'
end