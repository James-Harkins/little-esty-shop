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
end
