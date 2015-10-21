class LocationsController < ApplicationController

  def index
    @locations = Location.all
  end

  def new
    build_location_form
  end

  def create
    build_location_form
    options = { flash: { success: "You've successfully created a location." } }
    save_location_form(options) or render "new"
  end

  def show
    load_location_form
  end

  def update
    load_location_form
    build_location_form
    options = { flash: { success: "You've successfully updated location." } }
    save_location_form(options) or render "show"
  end

  def destroy
    @location ||= Location.find(params[:id])
    @location.destroy
    redirect_to locations_path, flash: { success: "You've successfully deleted this location." }
  end

  private
  def location_params
    params.require(:location).permit!
  end

  def build_location_form
    @location ||= LocationForm.new(Location.new)
  end

  def load_location_form
    @location ||= LocationForm.new(Location.find(params[:id]))
  end

  def save_location_form(options)
    if @location.validate(params[:location])
      @location.save
      redirect_to locations_path, options
    end
  end


end
