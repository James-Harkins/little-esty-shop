require 'rails_helper'

RSpec.describe 'merchant_bulk_discounts new page' do
  describe 'as a user' do
    describe 'when i visit the merchant_bulk_discounts new page' do
      it 'i see a form to add a new bulk_discount, which redirects me back to the
          merchant_bulk_discounts index page where my new bulk_discount is listed' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage: 20, quantity_threshold: 10)
        bulk_discount_2 = merchant_1.bulk_discounts.create!(percentage: 30, quantity_threshold: 15)

        merchant_2 = Merchant.create!(name: "John's Bars")
        bulk_discount_3 = merchant_2.bulk_discounts.create!(percentage: 50, quantity_threshold: 20)

        visit "/merchants/#{merchant_1.id}/bulk_discounts/new"

        fill_in :percentage, with: 10
        fill_in :quantity_threshold, with: 5

        click_button 'Submit'

        expect(current_path).to eq("/merchants/#{merchant_1.id}/bulk_discounts")

        expect(page).to have_content(bulk_discount_1.percentage)
        expect(page).to have_content(bulk_discount_1.quantity_threshold)
        expect(page).to have_content(bulk_discount_2.percentage)
        expect(page).to have_content(bulk_discount_2.quantity_threshold)
        expect(page).to have_content("10% off")
        expect(page).to have_content("For 5 or more items")
        expect(page).not_to have_content(bulk_discount_3.percentage)
        expect(page).not_to have_content("For #{bulk_discount_3.quantity_threshold} or more items")
      end

      it 'shows a flash error if user inputs invalid data' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage: 20, quantity_threshold: 10)
        bulk_discount_2 = merchant_1.bulk_discounts.create!(percentage: 30, quantity_threshold: 15)

        merchant_2 = Merchant.create!(name: "John's Bars")
        bulk_discount_3 = merchant_2.bulk_discounts.create!(percentage: 50, quantity_threshold: 20)

        visit "/merchants/#{merchant_1.id}/bulk_discounts/new"

        fill_in :percentage, with: 200
        fill_in :quantity_threshold, with: 1

        click_button 'Submit'

        expect(page).to have_content("Invalid Data: Percentage must be a whole number between 1 and 99 and Quantity Threshold must be a whole number greater than 1")

        fill_in :percentage, with: 99
        fill_in :quantity_threshold, with: 1

        click_button 'Submit'

        expect(page).to have_content("Invalid Data: Percentage must be a whole number between 1 and 99 and Quantity Threshold must be a whole number greater than 1")

        fill_in :percentage, with: 10
        fill_in :quantity_threshold, with: 5

        click_button 'Submit'

        expect(current_path).to eq("/merchants/#{merchant_1.id}/bulk_discounts")

        expect(page).to have_content(bulk_discount_1.percentage)
        expect(page).to have_content(bulk_discount_1.quantity_threshold)
        expect(page).to have_content(bulk_discount_2.percentage)
        expect(page).to have_content(bulk_discount_2.quantity_threshold)
        expect(page).to have_content("10% off")
        expect(page).to have_content("For 5 or more items")
        expect(page).not_to have_content(bulk_discount_3.percentage)
        expect(page).not_to have_content("For #{bulk_discount_3.quantity_threshold} or more items")
      end
    end
  end
end
