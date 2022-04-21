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
        expect(page).to_not have_content("Polearm")
  end
   it 'shows total revenue' do
        merchant = Merchant.create(name: "Braum's")
        merchant2 = Merchant.create(name: "Target")

        item1 = merchant.items.create(name: "Toast", description: "Let it rip!", unit_price: 1000)
        item2 = merchant.items.create(name: "Polearm", description: "Let it rip!", unit_price: 1000)

        bob = Customer.create!(first_name: "Bob", last_name: "Benson")

        invoice_1 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
        invoice_2 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')

        invoice_item_1 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:45, unit_price: 1000)
        invoice_item_2 = item2.invoice_items.create(invoice_id:invoice_1.id, quantity:222, unit_price: 1000)
        visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"

        expect(page).to have_content("267000")

  end

  describe 'as a merchant' do
    describe 'when i visit my merchant invoice show page' do
      before :each do
        @merchant_1 = Merchant.create!(name: "Jim's Rare Guitars")
        @item_1 = @merchant_1.items.create!(name: "1959 Gibson Les Paul",
                                        description: "Tobacco Burst Finish, Rosewood Fingerboard",
                                        unit_price: 25000000)
        @item_2 = @merchant_1.items.create!(name: "1954 Fender Stratocaster",
                                        description: "Seafoam Green Finish, Maple Fingerboard",
                                        unit_price: 10000000)
        @item_3 = @merchant_1.items.create!(name: "1968 Gibson SG",
                                        description: "Cherry Red Finish, Rosewood Fingerboard",
                                        unit_price: 400000,
                                        status: 1)
        @customer = Customer.create!(first_name: "Steven", last_name: "Seagal")
        @invoice_1 = @customer.invoices.create!(status: 1)
        @invoice_2 = @customer.invoices.create!(status: 0)
        @invoice_item_1 = @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity:45, unit_price: 1000, status: 0)
        @invoice_item_2 = @item_2.invoice_items.create!(invoice_id: @invoice_1.id, quantity:222, unit_price: 1000, status: 2)
        @invoice_item_3 = @item_2.invoice_items.create!(invoice_id: @invoice_2.id, quantity:222, unit_price: 1000, status: 1)
        @invoice_item_4 = @item_3.invoice_items.create!(invoice_id: @invoice_1.id, quantity:222, unit_price: 1000, status: 1)

        visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
      end

      it "i see that each invoice item status is a select field
          and i see that the invoice item's current status is selected" do

        within "#item-#{@invoice_item_1.id}" do
          expect(page).to have_select(:status, selected: 'Pending')
        end

        within "#item-#{@invoice_item_2.id}" do
          expect(page).to have_select(:status, selected: 'Shipped')
        end

        within "#item-#{@invoice_item_4.id}" do
          expect(page).to have_select(:status, selected: 'Packaged')
        end
      end

      it "can update the item status" do

        within "#item-#{@invoice_item_4.id}" do
          select 'Shipped', :from => :status
          click_button("Update Item Status")
        end

        expect(current_path).to eq("/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}")

        within "#item-#{@invoice_item_4.id}" do
          expect(page).to have_select(:status, selected: 'Shipped')
        end

        within "#item-#{@invoice_item_1.id}" do
          expect(page).to have_select(:status, selected: 'Pending')
        end

        within "#item-#{@invoice_item_2.id}" do
          expect(page).to have_select(:status, selected: 'Shipped')
        end
      end
    end
  end
end
