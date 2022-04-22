require 'rails_helper'

RSpec.describe 'merchant_discounts index page' do
  describe 'as a user' do
    describe 'when i visit my discounts index page' do
      it 'i see all of my bulk discounts and their percentage and quantity thresholds' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 10)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 15)

        merchant_2 = Merchant.create!(name: "John's Bars")
        discount_3 = merchant_2.discounts.create!(percentage: 50, quantity_threshold: 20)

        visit "/merchants/#{merchant_1.id}/discounts"

        expect(page).to have_content(discount_1.percentage)
        expect(page).to have_content(discount_1.quantity_threshold)
        expect(page).to have_content(discount_2.percentage)
        expect(page).to have_content(discount_2.quantity_threshold)
        expect(page).not_to have_content(discount_3.percentage)
        expect(page).not_to have_content("For #{discount_3.quantity_threshold} or more items")
      end

      it 'i also see a link to each discount show page' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 10)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 15)

        merchant_2 = Merchant.create!(name: "John's Bars")
        discount_3 = merchant_2.discounts.create!(percentage: 50, quantity_threshold: 20)

        visit "/merchants/#{merchant_1.id}/discounts"

        within "#discount-#{discount_1.id}" do
          click_link "More Details"
        end

        expect(current_path).to eq("/merchants/#{merchant_1.id}/discounts/#{discount_1.id}")
      end

      it 'i see a link to create a new discount' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 10)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 15)

        visit "/merchants/#{merchant_1.id}/discounts"

        click_link "Create New Discount"

        expect(current_path).to eq("/merchants/#{merchant_1.id}/discounts/new")
      end

      it 'next to each discount i see a link to delete it, which when clicked,
          redirects me back to the index page where that discount is no longer listed' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 10)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 15)

        merchant_2 = Merchant.create!(name: "John's Bars")
        discount_3 = merchant_2.discounts.create!(percentage: 50, quantity_threshold: 20)

        visit "/merchants/#{merchant_1.id}/discounts"

        within "#discount-#{discount_1.id}" do
          click_link "Delete This Discount"
        end

        expect(current_path).to eq("/merchants/#{merchant_1.id}/discounts")

        expect(page).not_to have_content(discount_1.percentage)
        expect(page).not_to have_content(discount_1.quantity_threshold)
        expect(page).to have_content(discount_2.percentage)
        expect(page).to have_content(discount_2.quantity_threshold)
        expect(page).not_to have_content(discount_3.percentage)
        expect(page).not_to have_content("For #{discount_3.quantity_threshold} or more items")
      end
    end
  end
end
