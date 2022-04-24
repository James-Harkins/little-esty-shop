class MerchantDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidayFacade.new
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchants/#{merchant.id}/discounts"
    else
      redirect_to "/merchants/#{merchant.id}/discounts/new"
      flash[:invalid_data] = "Invalid Data: Percentage must be a whole number between 1 and 99 and Quantity Threshold must be a whole number greater than 1"
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    if discount.update(discount_params)
      redirect_to "/merchants/#{discount.merchant_id}/discounts/#{discount.id}"
    else
      redirect_to "/merchants/#{discount.merchant_id}/discounts/#{discount.id}/edit"
      flash[:invalid_data] = "Invalid Data: Percentage must be a whole number between 1 and 99 and Quantity Threshold must be a whole number greater than 1"
    end
  end

  def destroy
    Discount.destroy(params[:id])
    redirect_to "/merchants/#{params[:merchant_id]}/discounts"
  end

  private
  def discount_params
    params.permit(:percentage, :quantity_threshold)
  end
end
