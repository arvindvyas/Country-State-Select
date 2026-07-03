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
      # value (ISO code) and element 1 as the label. Goes through the
      # configured data source (not `CS` directly) so a custom adapter and
      # only/except/priority filtering apply here too.
      render_cached(CountryStateSelect.raw_states(params[:country_id]), params[:country_id])
    end

    # Send it a state_id and country_id; returns the cities of that state.
    def find_cities
      render_cached(
        CountryStateSelect.collect_cities(params[:state_id], params[:country_id]),
        [params[:state_id], params[:country_id]]
      )
    end

    private

    # The underlying data is static per params, so this is safe to cache
    # both at the HTTP layer (Cache-Control) and via conditional GET
    # (ETag/304), avoiding a render entirely on repeat lookups. Disabled by
    # setting `CountryStateSelect.configuration.cache_duration = nil`.
    def render_cached(data, cache_key)
      duration = CountryStateSelect.configuration.cache_duration

      if duration
        expires_in duration, public: true
        return unless stale?(etag: cache_key)
      end

      respond_to do |format|
        format.json { render json: data }
      end
    end
  end
end
