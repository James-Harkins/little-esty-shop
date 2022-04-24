require 'rails_helper'

RSpec.describe "Admin Invoices Show" do
  it 'displays invoice info relating to invoice' do
    bob = Customer.create!(first_name: "Bob", last_name: "Benson")
    invoice_1 = bob.invoices.create!(status: 1, created_at: '01 Jul 2022 01:00:00')
    invoice_2 = bob.invoices.create!(status: 1, created_at: '02 Apr 2022 01:00:00')

    visit "/admin/invoices/#{invoice_1.id}"

    expect(page).to have_content("#{invoice_1.id}")
    expect(page).to have_content("Completed")
    expect(page).to have_content("Bob Benson")
    expect(page).to have_content('Friday, July 01, 2022')
    expect(page).to have_no_content('Saturday, April 02, 2022')
  end

  it 'displays all the items and item info' do
    walmart = Merchant.create!(name: "Wal-Mart")
    bob = Customer.create!(first_name: "Bob", last_name: "Benson")
    item_1 = walmart.items.create!(name: "pickle", description: "sour cucumber", unit_price: 300)
    item_2 = walmart.items.create!(name: "eraser", description: "rubber bit", unit_price: 200)

    invoice_1 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')

    InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 6, status: 1, unit_price: 295)
    InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 2, status: 0, unit_price: 215)

    visit "/admin/invoices/#{invoice_1.id}"

    within("#item-#{item_1.id}") do
      expect(page).to have_content("pickle")
      expect(page).to have_content("6")
      expect(page).to have_content("$2.95")
      expect(page).to have_content("packaged")
      expect(page).to have_no_content("eraser")
    end

    within("#item-#{item_2.id}") do
      expect(page).to have_content("eraser")
      expect(page).to have_content("2")
      expect(page).to have_content("$2.15")
      expect(page).to have_content("pending")
      expect(page).to have_no_content("pickle")
    end
  end

  it 'displays the total revenue for the invoice' do
    walmart = Merchant.create!(name: "Wal-Mart")
    bob = Customer.create!(first_name: "Bob", last_name: "Benson")
    item_1 = walmart.items.create!(name: "pickle", description: "sour cucumber", unit_price: 300)
    item_2 = walmart.items.create!(name: "eraser", description: "rubber bit", unit_price: 200)

    invoice_1 = bob.invoices.create!(status: 0, created_at: '05 Apr 2022 00:53:36 UTC +00:00')

    InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 6, status: 1, unit_price: 295)
    InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 2, status: 0, unit_price: 215)

    visit "/admin/invoices/#{invoice_1.id}"

    expect(page).to have_content("$22.00")
  end

  it 'has a select field for status that can update the status' do
    walmart = Merchant.create!(name: "Wal-Mart")
    bob = Customer.create!(first_name: "Bob", last_name: "Benson")
    item_1 = walmart.items.create!(name: "pickle", description: "sour cucumber", unit_price: 300)
    item_2 = walmart.items.create!(name: "eraser", description: "rubber bit", unit_price: 200)

    invoice_1 = bob.invoices.create!(status: 0, created_at: '05 Apr 2022 00:53:36 UTC +00:00')

    InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 6, status: 1, unit_price: 295)
    InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 2, status: 0, unit_price: 215)

    visit "/admin/invoices/#{invoice_1.id}"

    expect(page).to have_select(:status, selected: 'In Progress')

    select 'Completed', :from => :status
    click_button("Update Status")

    expect(page).to have_select(:status, selected: 'Completed')

    select 'Cancelled', :from => :status
    click_button("Update Status")

    expect(page).to have_select(:status, selected: 'Cancelled')
  end

  describe 'bulk discounts' do
    before :each do
      @merchant_1 = Merchant.create!(name: "Jim's Rare Guitars")
      @merchant_2 = Merchant.create!(name: "Bill's Less Rare Guitars")
      @item_1 = @merchant_1.items.create!(name: "1959 Gibson Les Paul",
                                      description: "Tobacco Burst Finish, Rosewood Fingerboard",
                                      unit_price: 25000)
      @item_2 = @merchant_1.items.create!(name: "1954 Fender Stratocaster",
                                      description: "Seafoam Green Finish, Maple Fingerboard",
                                      unit_price: 10000)
      @item_3 = @merchant_1.items.create!(name: "1968 Gibson SG",
                                      description: "Cherry Red Finish, Rosewood Fingerboard",
                                      unit_price: 400)
      @item_4 = @merchant_1.items.create!(name: "1984 Gibson Les Paul",
                                      description: "Sunburst Finish, Maple Fingerboard",
                                      unit_price: 600)
      @item_5 = @merchant_1.items.create!(name: "1991 Gibson Les Paul",
                                      description: "Sunburst Finish, Maple Fingerboard",
                                      unit_price: 900)
      @item_6 = @merchant_2.items.create!(name: "1993 Gibson Les Paul",
                                      description: "Sunburst Finish, Maple Fingerboard",
                                      unit_price: 700)
      @item_7 = @merchant_2.items.create!(name: "2004 Gibson Les Paul",
                                      description: "Sunburst Finish, Maple Fingerboard",
                                      unit_price: 200)
      @item_8 = @merchant_2.items.create!(name: "1997 Gibson Les Paul",
                                      description: "Sunburst Finish, Maple Fingerboard",
                                      unit_price: 100)
      @item_9 = @merchant_2.items.create!(name: "1996 Gibson Les Paul",
                                      description: "Sunburst Finish, Maple Fingerboard",
                                      unit_price: 100)
      @item_10 = @merchant_2.items.create!(name: "1975 Gibson Les Paul",
                                      description: "Sunburst Finish, Maple Fingerboard",
                                      unit_price: 400)
      @customer_1 = Customer.create!(first_name: "Guthrie", last_name: "Govan")

      @invoice_1 = @customer_1.invoices.create!(status: 1)
      @invoice_2 = @customer_1.invoices.create!(status: 0)
      @invoice_item_1 = InvoiceItem.create!(item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 5, status: 0)
      @invoice_item_2 = InvoiceItem.create!(item: @item_2, invoice: @invoice_1, quantity: 20, unit_price: 10, status: 0)
      @invoice_item_3 = InvoiceItem.create!(item: @item_3, invoice: @invoice_1, quantity: 25, unit_price: 20, status: 0)
      @invoice_item_4 = InvoiceItem.create!(item: @item_4, invoice: @invoice_1, quantity: 10, unit_price: 5, status: 0)
      @invoice_item_5 = InvoiceItem.create!(item: @item_5, invoice: @invoice_1, quantity: 15, unit_price: 10, status: 0)
      @invoice_item_6 = InvoiceItem.create!(item: @item_6, invoice: @invoice_1, quantity: 30, unit_price: 25, status: 0)
      @invoice_item_7 = InvoiceItem.create!(item: @item_7, invoice: @invoice_1, quantity: 35, unit_price: 10, status: 0)
      @invoice_item_8 = InvoiceItem.create!(item: @item_8, invoice: @invoice_1, quantity: 10, unit_price: 15, status: 0)
      @invoice_item_9 = InvoiceItem.create!(item: @item_9, invoice: @invoice_1, quantity: 31, unit_price: 5, status: 0)
      @invoice_item_10 = InvoiceItem.create!(item: @item_10, invoice: @invoice_1, quantity: 4, unit_price: 20, status: 0)
      @invoice_item_11 = InvoiceItem.create!(item: @item_5, invoice: @invoice_2, quantity: 10000, unit_price: 25, status: 0)
      @invoice_item_12 = InvoiceItem.create!(item: @item_7, invoice: @invoice_2, quantity: 10000, unit_price: 50, status: 0)
      @invoice_item_13 = InvoiceItem.create!(item: @item_8, invoice: @invoice_2, quantity: 10000, unit_price: 20, status: 0)
      @discount_1 = @merchant_1.discounts.create!(percentage: 20, quantity_threshold: 20)
      @discount_2 = @merchant_2.discounts.create!(percentage: 40, quantity_threshold: 30)

      visit "/admin/invoices/#{@invoice_1.id}"
    end

    it 'displays the invoices total revenue' do
      expect(page).to have_content("Total Revenue: $23.90")
    end

    it 'displays the invoices discounted revenue' do
      expect(page).to have_content("Revenue after Discounts: $17.48")
    end
  end
end
