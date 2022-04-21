require 'rails_helper'

RSpec.describe 'merchant invoices index page' do
  describe 'as a user' do
    describe 'when i visit my merchants invoices index page' do
      it 'i see all of the invoices that include at least one of my merchants
          items, as well as its id, which is a link to its show page' do
        merchant_1 = Merchant.create!(name: "Jim's Rare Guitars")
        item_1 = merchant_1.items.create!(name: "1959 Gibson Les Paul",
                                        description: "Tobacco Burst Finish, Rosewood Fingerboard",
                                        unit_price: 25000000)
        item_2 = merchant_1.items.create!(name: "1954 Fender Stratocaster",
                                        description: "Seafoam Green Finish, Maple Fingerboard",
                                        unit_price: 10000000)
        item_3 = merchant_1.items.create!(name: "1968 Gibson SG",
                                        description: "Cherry Red Finish, Rosewood Fingerboard",
                                        unit_price: 400000)
        merchant_2 = Merchant.create!(name: "Bob's Less Rare Guitars")
        item_4 = merchant_2.items.create!(name: "2006 Ibanez GX500",
                                          description: "Green Burst Finish, Rosewood Fingerboard",
                                          unit_price: 50000)
        item_5 = merchant_2.items.create!(name: "2013 ESP GH100",
                                          description: "Black Finish, Ebony Fingerboard",
                                          unit_price: 40000)
        customer_1 = Customer.create!(first_name: "Guthrie", last_name: "Govan")
        invoice_1 = customer_1.invoices.create!(status: 1)
        invoice_2 = customer_1.invoices.create!(status: 0)
        invoice_3 = customer_1.invoices.create!(status: 1)
        invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, quantity: 1, unit_price: item_1.unit_price, status: 0)
        invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice_2, quantity: 25, unit_price: item_2.unit_price, status: 0)
        invoice_item_3 = InvoiceItem.create!(item: item_3, invoice: invoice_2, quantity: 1, unit_price: item_3.unit_price, status: 0)
        invoice_item_4 = InvoiceItem.create!(item: item_4, invoice: invoice_1, quantity: 31, unit_price: item_4.unit_price, status: 0)
        invoice_item_5 = InvoiceItem.create!(item: item_5, invoice: invoice_1, quantity: 35, unit_price: item_5.unit_price, status: 0)
        invoice_item_5 = InvoiceItem.create!(item: item_4, invoice: invoice_3, quantity: 35, unit_price: item_5.unit_price, status: 0)

        visit "/merchants/#{merchant_1.id}/invoices"

        expect(page).to have_content(invoice_1.status)
        expect(page).to have_link("#{invoice_1.id}")
        expect(page).to have_content(invoice_2.status)
        expect(page).to have_link("#{invoice_2.id}")

        expect(page).not_to have_link("#{invoice_3.id}")

        within "#invoice-#{invoice_2.id}" do
          click_link "#{invoice_2.id}"
        end

        expect(current_path).to eq("/merchants/#{merchant_1.id}/invoices/#{invoice_2.id}")
      end
    end
  end
end
