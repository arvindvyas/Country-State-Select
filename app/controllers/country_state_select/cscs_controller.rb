# frozen_string_literal: true

# @author : Arvind Vyas
module CountryStateSelect
  class CscsController < ApplicationController
    def find_states
      csc = CS.states(params[:country_id])

      respond_to do |format|
        format.json { render json: csc.to_a }
      end
    end

    # Sent it to state_id and  country id it will return cities of that states
    def find_cities
      cities = CS.cities(params[:state_id].to_sym, params[:country_id].to_sym)

      respond_to do |format|
        format.json { render json: cities.to_a }
      end
    end
  end
end
