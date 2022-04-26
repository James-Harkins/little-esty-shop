class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidayFacade.new
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      redirect_to "/merchants/#{merchant.id}/bulk_discounts"
    else
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/new"
      flash[:invalid_data] = "Invalid Data: Percentage must be a whole number between 1 and 99 and Quantity Threshold must be a whole number greater than 1"
    end
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    bulk_discount = BulkDiscount.find(params[:id])
    if bulk_discount.update(bulk_discount_params)
      redirect_to "/merchants/#{bulk_discount.merchant_id}/bulk_discounts/#{bulk_discount.id}"
    else
      redirect_to "/merchants/#{bulk_discount.merchant_id}/bulk_discounts/#{bulk_discount.id}/edit"
      flash[:invalid_data] = "Invalid Data: Percentage must be a whole number between 1 and 99 and Quantity Threshold must be a whole number greater than 1"
    end
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts"
  end

  private
  def bulk_discount_params
    params.permit(:percentage, :quantity_threshold)
  end
end
