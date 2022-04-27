class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def update
    invoice = Invoice.find(params[:id])
    invoice.update(status: params[:status])
    if params[:status] == "completed"
      invoice.invoice_items.each do |invoice_item|
        if invoice_item.applied_bulk_discount
          invoice_item.update(discount_percentage: invoice_item.discount_percentage - invoice_item.applied_bulk_discount.percentage)
        end
      end
    end
    redirect_to admin_invoice_path
  end
end
