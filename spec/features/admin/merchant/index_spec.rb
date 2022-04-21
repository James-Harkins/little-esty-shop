require 'rails_helper'
require 'rake'
Rails.application.load_tasks

RSpec.describe "Admin Merchants Index" do
  it 'displays a header showing the Admin Merchants Index' do
    visit '/admin/merchants'

    within(".header") do
      expect(page).to have_content("Merchant Index - Admin")
    end
  end

  it 'displays all of the merchants' do
    merchant_1 = Merchant.create!(name: "Mollys", status: 1)
    merchant_2 = Merchant.create!(name: "Berrys", status: 1)
    merchant_3 = Merchant.create!(name: "Jimmys", status: 0)

    visit '/admin/merchants'

    within("#enabled-merchants") do
      expect(page).to have_content('Mollys')
      expect(page).to have_content('Berrys')
      expect(page).to_not have_content('Jimmys')
    end

    within("#disabled-merchants") do
      expect(page).to have_content('Jimmys')
      expect(page).to_not have_content('Mollys')
      expect(page).to_not have_content('Berrys')
    end
  end

  it 'contains a button to enable or disable' do
    merchant_1 = Merchant.create!(name: "Mollys", status: 1)
    merchant_2 = Merchant.create!(name: "Berrys", status: 1)
    merchant_3 = Merchant.create!(name: "Jimmys", status: 0)

    visit '/admin/merchants'

    within("#merchant-#{merchant_1.id}") do
      expect(page).to have_button("Disable")
    end

    within("#merchant-#{merchant_2.id}") do
      expect(page).to have_button("Disable")
    end

    within("#merchant-#{merchant_3.id}") do
      expect(page).to have_button("Enable")
    end
  end

  it 'updates a merchant between enable/disable' do
    merchant_1 = Merchant.create!(name: "Mollys", status: 1)
    merchant_2 = Merchant.create!(name: "Jerrys", status: 1)
    merchant_3 = Merchant.create!(name: "Berrys", status: 0)

    visit '/admin/merchants'

    expect(merchant_1.status).to eq("enabled")
    expect(merchant_2.status).to eq("enabled")
    expect(merchant_3.status).to eq("disabled")
    expect(page).to have_button("Enable")
    expect(page).to have_button("Disable")
  end

  it 'shows top five merchants' do
    merchant1 = Merchant.create(name: "Merchant 1")
    merchant2 = Merchant.create(name: "Merchant 2")
    merchant3 = Merchant.create(name: "Merchant 3")
    merchant4 = Merchant.create(name: "Merchant 4")
    merchant5 = Merchant.create(name: "Merchant 5")
    merchant6 = Merchant.create(name: "Merchant 6")
    merchant7 = Merchant.create(name: "Merchant 7")

    item1 = merchant1.items.create(name: "Apple", description: "Let it rip!", unit_price: 1500)
    item2 = merchant1.items.create(name: "Banana", description: "Let it rip!", unit_price: 2000)
    item3 = merchant2.items.create(name: "Coconut", description: "Let it rip!", unit_price: 700)
    item4 = merchant3.items.create(name: "Date", description: "Let it rip!", unit_price: 123)
    item5 = merchant4.items.create(name: "Eggplant", description: "Let it rip!", unit_price: 500)
    item6 = merchant5.items.create(name: "Fennel", description: "Let it rip!", unit_price: 60)
    item7 = merchant6.items.create(name: "Grape", description: "Let it rip!", unit_price: 10)
    item8 = merchant7.items.create(name: "Habenero", description: "Let it rip!", unit_price: 325)

    bob = Customer.create!(first_name: "Bob", last_name: "Benson")
    dave = Customer.create!(first_name: "Dave", last_name: "Fogherty")

    invoice_1 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_2 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_3 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_4 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_5 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_6 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_7 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_8 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_9 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_10 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_11 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_12 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')

    invoice_item_1 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:21, unit_price: 1500)
    invoice_item_2 = item2.invoice_items.create(invoice_id:invoice_1.id, quantity:10, unit_price: 2000)
    invoice_item_3 = item3.invoice_items.create(invoice_id:invoice_1.id, quantity:13, unit_price: 700)
    invoice_item_4 = item4.invoice_items.create(invoice_id:invoice_1.id, quantity:2, unit_price: 123)
    invoice_item_5 = item5.invoice_items.create(invoice_id:invoice_1.id, quantity:9, unit_price: 500)
    invoice_item_6 = item6.invoice_items.create(invoice_id:invoice_1.id, quantity:19, unit_price: 60)
    invoice_item_7 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:12, unit_price: 10)
    invoice_item_8 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:11, unit_price: 1500)
    invoice_item_9 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:10, unit_price: 1500)
    invoice_item_10 = item2.invoice_items.create(invoice_id:invoice_1.id, quantity:8, unit_price: 2000)
    invoice_item_11 = item2.invoice_items.create(invoice_id:invoice_1.id, quantity:31, unit_price: 2000)
    invoice_item_12 = item3.invoice_items.create(invoice_id:invoice_1.id, quantity:1, unit_price: 700)

    transactions_1 = invoice_1.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_2 = invoice_2.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_3 = invoice_3.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_4 = invoice_4.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_5 = invoice_5.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_6 = invoice_6.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_7 = invoice_7.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_8 = invoice_8.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_9 = invoice_9.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_10 = invoice_10.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_11 = invoice_11.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_12 = invoice_12.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )

    visit '/admin/merchants'
    within("#top-by-revenue") do
      expect(page).to have_content('Merchant 1 $1611.20')
      expect(page).to have_content('Merchant 2 $98.00')
      expect(page).to have_content('Merchant 4 $45.00')
      expect(page).to have_content('Merchant 5 $11.40')
      expect(page).to have_content('Merchant 3 $2.46')
      expect(page).to_not have_content("Merchant 6")
    end
  end

  it 'merchant name is a link to that merchants show page' do
    merchant1 = Merchant.create(name: "Merchant 1")
    merchant2 = Merchant.create(name: "Merchant 2")
    merchant3 = Merchant.create(name: "Merchant 3")
    merchant4 = Merchant.create(name: "Merchant 4")
    merchant5 = Merchant.create(name: "Merchant 5")
    merchant6 = Merchant.create(name: "Merchant 6")
    merchant7 = Merchant.create(name: "Merchant 7")

    item1 = merchant1.items.create(name: "Apple", description: "Let it rip!", unit_price: 1500)
    item2 = merchant1.items.create(name: "Banana", description: "Let it rip!", unit_price: 2000)
    item3 = merchant2.items.create(name: "Coconut", description: "Let it rip!", unit_price: 700)
    item4 = merchant3.items.create(name: "Date", description: "Let it rip!", unit_price: 123)
    item5 = merchant4.items.create(name: "Eggplant", description: "Let it rip!", unit_price: 500)
    item6 = merchant5.items.create(name: "Fennel", description: "Let it rip!", unit_price: 60)
    item7 = merchant6.items.create(name: "Grape", description: "Let it rip!", unit_price: 10)
    item8 = merchant7.items.create(name: "Habenero", description: "Let it rip!", unit_price: 325)

    bob = Customer.create!(first_name: "Bob", last_name: "Benson")
    dave = Customer.create!(first_name: "Dave", last_name: "Fogherty")

    invoice_1 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_2 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_3 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_4 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_5 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_6 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_7 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_8 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_9 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_10 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_11 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
    invoice_12 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')

    invoice_item_1 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:21, unit_price: 1500)
    invoice_item_2 = item2.invoice_items.create(invoice_id:invoice_1.id, quantity:10, unit_price: 2000)
    invoice_item_3 = item3.invoice_items.create(invoice_id:invoice_1.id, quantity:13, unit_price: 700)
    invoice_item_4 = item4.invoice_items.create(invoice_id:invoice_1.id, quantity:2, unit_price: 123)
    invoice_item_5 = item5.invoice_items.create(invoice_id:invoice_1.id, quantity:9, unit_price: 500)
    invoice_item_6 = item6.invoice_items.create(invoice_id:invoice_1.id, quantity:19, unit_price: 60)
    invoice_item_7 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:12, unit_price: 10)
    invoice_item_8 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:11, unit_price: 1500)
    invoice_item_9 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:10, unit_price: 1500)
    invoice_item_10 = item2.invoice_items.create(invoice_id:invoice_1.id, quantity:8, unit_price: 2000)
    invoice_item_11 = item2.invoice_items.create(invoice_id:invoice_1.id, quantity:31, unit_price: 2000)
    invoice_item_12 = item3.invoice_items.create(invoice_id:invoice_1.id, quantity:1, unit_price: 700)

    transactions_1 = invoice_1.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_2 = invoice_2.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_3 = invoice_3.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_4 = invoice_4.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_5 = invoice_5.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_6 = invoice_6.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_7 = invoice_7.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_8 = invoice_8.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_9 = invoice_9.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_10 = invoice_10.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_11 = invoice_11.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
    transactions_12 = invoice_12.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )

    visit '/admin/merchants'

    within("#top-by-revenue") do
      click_link("Merchant 1")
    end

    expect(page).to have_current_path("/admin/merchants/#{merchant1.id}")
  end

  describe 'merchant best day displayed next to top merchants' do
    it 'displays the top date for a top merchant' do
      date_1 = Time.parse("2016-07-25")
      date_2 = Time.parse("2022-04-05")
      date_3 = Time.parse("2018-09-01")
      merchant1 = Merchant.create!(name: "Merchant 1")
      merchant2 = Merchant.create!(name: "Merchant 2")
      item1 = merchant1.items.create(name: "Apple", description: "Let it rip!", unit_price: 1500)
      item2 = merchant2.items.create(name: "Coconut", description: "Let it rip!", unit_price: 700)
      bob = Customer.create!(first_name: "Bob", last_name: "Benson")
      dave = Customer.create!(first_name: "Dave", last_name: "Fogherty")
      invoice_1 = bob.invoices.create!(status: 1, created_at: date_1)
      invoice_2 = bob.invoices.create!(status: 1, created_at: date_2)
      invoice_3 = bob.invoices.create!(status: 1, created_at: date_2)
      invoice_4 = bob.invoices.create!(status: 1, created_at: date_3)
      invoice_5 = bob.invoices.create!(status: 1, created_at: date_3)
      invoice_item_1 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:21, unit_price: 1)
      invoice_item_2 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:10, unit_price: 1)
      invoice_item_3 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:13, unit_price: 1)
      invoice_item_4 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:2, unit_price: 1)
      invoice_item_5 = item1.invoice_items.create(invoice_id:invoice_2.id, quantity:1, unit_price: 1)
      invoice_item_6 = item1.invoice_items.create(invoice_id:invoice_2.id, quantity:50, unit_price: 1)
      invoice_item_7 = item1.invoice_items.create(invoice_id:invoice_2.id, quantity:1, unit_price: 1)
      invoice_item_8 = item1.invoice_items.create(invoice_id:invoice_2.id, quantity:1, unit_price: 1)
      invoice_item_9 = item1.invoice_items.create(invoice_id:invoice_2.id, quantity:1, unit_price: 1)
      invoice_item_10 = item2.invoice_items.create(invoice_id:invoice_3.id, quantity:8, unit_price: 1)
      invoice_item_11 = item2.invoice_items.create(invoice_id:invoice_3.id, quantity:150000, unit_price: 1)
      invoice_item_12 = item2.invoice_items.create(invoice_id:invoice_3.id, quantity:1, unit_price: 1)
      invoice_item_12 = item1.invoice_items.create(invoice_id:invoice_4.id, quantity:30, unit_price: 1)
      invoice_item_12 = item1.invoice_items.create(invoice_id:invoice_5.id, quantity:30, unit_price: 1)
      transactions_1 = invoice_1.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
      transactions_2 = invoice_2.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
      transactions_3 = invoice_3.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )

      visit "/admin/merchants"

      within("#top-by-revenue") do
        expect(page).to have_content("2018-09-01")
      end
    end
  end
end
