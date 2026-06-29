# frozen_string_literal: true

# @author : Arvind Vyas
module CountryStateSelect
  class CscsController < ApplicationController
    # These are read-only data lookups served over GET, so CSRF tokens are not
    # required. Skipping forgery protection also keeps the endpoints usable when
    # a host app still wires them up as POST without sending a token.
    skip_forgery_protection if respond_to?(:skip_forgery_protection)

    def find_states
      # `[[code, name], ...]` shape — the front-end uses element 0 as the option
      # value (ISO code) and element 1 as the label.
      states = CS.states(params[:country_id]).to_a

      respond_to do |format|
        format.json { render json: states }
      end
    end

    # Send it a state_id and country_id; returns the cities of that state.
    def find_cities
      cities = CountryStateSelect.collect_cities(params[:state_id], params[:country_id])

      respond_to do |format|
        format.json { render json: cities }
      end
    end
  end
end
