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

    expect(page).to have_content("Quantity: 45")
    expect(page).to have_content("Unit Price: $10.00")
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

    expect(page).to have_content("$2670.00")
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

    describe 'applying bulk discounts' do
      before :each do
        @merchant_1 = Merchant.create!(name: "Jim's Rare Guitars")
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
        @item_6 = @merchant_1.items.create!(name: "1993 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 700)
        @item_7 = @merchant_1.items.create!(name: "2004 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 200)
        @item_8 = @merchant_1.items.create!(name: "1997 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 100)
        @item_9 = @merchant_1.items.create!(name: "1996 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 100)
        @item_10 = @merchant_1.items.create!(name: "1975 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 400)
        @customer_1 = Customer.create!(first_name: "Guthrie", last_name: "Govan")

        @invoice_1 = @customer_1.invoices.create!(status: 1)
        @invoice_2 = @customer_1.invoices.create!(status: 0)
        @invoice_item_1 = InvoiceItem.create!(item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 5, status: 0)
        @invoice_item_2 = InvoiceItem.create!(item: @item_9, invoice: @invoice_1, quantity: 20, unit_price: 10, status: 0)
        @invoice_item_3 = InvoiceItem.create!(item: @item_2, invoice: @invoice_1, quantity: 10, unit_price: 20, status: 0)
        @invoice_item_4 = InvoiceItem.create!(item: @item_4, invoice: @invoice_1, quantity: 30, unit_price: 5, status: 0)
        @invoice_item_5 = InvoiceItem.create!(item: @item_3, invoice: @invoice_1, quantity: 35, unit_price: 10, status: 0)
        @invoice_item_6 = InvoiceItem.create!(item: @item_5, invoice: @invoice_1, quantity: 10, unit_price: 25, status: 0)
        @invoice_item_7 = InvoiceItem.create!(item: @item_6, invoice: @invoice_1, quantity: 5, unit_price: 10, status: 0)
        @invoice_item_8 = InvoiceItem.create!(item: @item_8, invoice: @invoice_1, quantity: 10, unit_price: 15, status: 0)
        @invoice_item_9 = InvoiceItem.create!(item: @item_7, invoice: @invoice_1, quantity: 1, unit_price: 5, status: 0)
        @invoice_item_10 = InvoiceItem.create!(item: @item_10, invoice: @invoice_1, quantity: 4, unit_price: 20, status: 0)
        @invoice_item_11 = InvoiceItem.create!(item: @item_5, invoice: @invoice_2, quantity: 10000, unit_price: 25, status: 0)
        @invoice_item_12 = InvoiceItem.create!(item: @item_7, invoice: @invoice_2, quantity: 10000, unit_price: 50, status: 0)
        @invoice_item_13 = InvoiceItem.create!(item: @item_8, invoice: @invoice_2, quantity: 10000, unit_price: 20, status: 0)
        @discount_1 = @merchant_1.discounts.create!(percentage: 20, quantity_threshold: 20)
        @discount_2 = @merchant_1.discounts.create!(percentage: 30, quantity_threshold: 40)

        visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
      end

      it 'i see the total revenue for the invoice' do
        expect(page).to have_content("Total Revenue: $14.40")
      end

      it 'i see the discounted revenue for the invoice' do
        expect(page).to have_content("Revenue after Discounts: $12.00")
      end
    end
  end
end
