require 'rails_helper'

RSpec.describe 'the merchant invoice show page' do
   it 'shows all the attributes for an invoice' do

        merchant = Merchant.create(name: "Braum's")
        item1 = merchant.items.create(name: "Toast", description: "Let it rip!", unit_price: 1000)
        bob = Customer.create!(first_name: "Bob", last_name: "Benson")
        invoice_1 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
        visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"
        expect(page).to have_content("#{invoice_1.id}")
        expect(page).to have_content("completed")
        expect(page).to have_content("Bob Benson")
        expect(page).to have_content('Tuesday, April 05, 2022')

  end


   it 'shows the quatity and price of item sold' do
        merchant = Merchant.create(name: "Braum's")
        item1 = merchant.items.create(name: "Toast", description: "Let it rip!", unit_price: 1000)
        bob = Customer.create!(first_name: "Bob", last_name: "Benson")
        invoice_1 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
        invoice_item_1 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:45, unit_price: 1000)
        visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"

        expect(page).to have_content("45")
        expect(page).to have_content("1000")
  end

   it 'the quatity and price of item sold' do
        merchant = Merchant.create(name: "Braum's")
        merchant2 = Merchant.create(name: "Target")

        item1 = merchant.items.create(name: "Toast", description: "Let it rip!", unit_price: 1000)
        item2 = merchant2.items.create(name: "Polearm", description: "Let it rip!", unit_price: 1000)

        bob = Customer.create!(first_name: "Bob", last_name: "Benson")
        dave = Customer.create!(first_name: "Dave", last_name: "Fogherty")

        invoice_1 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
        invoice_2 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')

        invoice_item_1 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:45, unit_price: 1000)
        invoice_item_2 = item2.invoice_items.create(invoice_id:invoice_1.id, quantity:222, unit_price: 1000)
        visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"

        expect(page).to_not have_content("222")
        expect(page).to_not have_content("3499")
        expect(page).to_not have_content("Dave")
        expect(page).to_not have_content("Fogherty")
  end
end
