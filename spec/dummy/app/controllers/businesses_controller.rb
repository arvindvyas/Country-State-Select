class BusinessesController < ApplicationController
  def new
    @business = Business.new
  end

  def create
    @business = Business.new(business_params)
    if @business.save
      redirect_to business_path(@business)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @business = Business.find(params[:id])
  end

  def edit
    @business = Business.find(params[:id])
  end

  def update
    @business = Business.find(params[:id])
    if @business.update(business_params)
      redirect_to business_path(@business)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def business_params
    params.require(:business).permit(:name, :country, :state, :city)
  end
end
