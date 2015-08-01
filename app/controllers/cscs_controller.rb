module CountryStateSelect
  class CscsController < ApplicationController
    
    def find_states
      csc =   CS.states(params[:country_id])
       
       respond_to do |format|
         format.json { render :json => csc}
      end

    end
  end
end