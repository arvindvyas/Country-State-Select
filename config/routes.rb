# frozen_string_literal: true

# Rails loads (evals) every engine's config/routes.rb as a plain file each
# time routes are drawn, expecting it to call `.draw` itself — that's why
# this isn't wrapped in the usual `Engine.routes.draw` block. Guarding on
# `draw_routes` here (rather than only documenting an opt-out) is what lets
# a host app disable the top-level /find_states, /find_cities routes and
# mount the engine at a custom path instead — see README "Custom route path".
if CountryStateSelect.configuration.draw_routes
  Rails.application.routes.draw do
    scope module: 'country_state_select' do
      # GET is the correct verb for these read-only lookups (and sidesteps CSRF).
      # POST is kept so existing host apps that wired the old routes keep working.
      match 'find_states' => 'cscs#find_states', via: %i[get post]
      match 'find_cities' => 'cscs#find_cities', via: %i[get post]
    end
  end
end
