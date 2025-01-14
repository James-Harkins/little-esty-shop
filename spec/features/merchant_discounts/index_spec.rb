require 'rails_helper'

RSpec.describe 'merchant_bulk_discounts index page' do
  describe 'as a user' do
    describe 'when i visit my bulk_discounts index page' do
      it 'i see all of my bulk bulk_discounts and their percentage and quantity thresholds' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage: 20, quantity_threshold: 10)
        bulk_discount_2 = merchant_1.bulk_discounts.create!(percentage: 30, quantity_threshold: 15)

        merchant_2 = Merchant.create!(name: "John's Bars")
        bulk_discount_3 = merchant_2.bulk_discounts.create!(percentage: 50, quantity_threshold: 20)

        visit "/merchants/#{merchant_1.id}/bulk_discounts"

        expect(page).to have_content(bulk_discount_1.percentage)
        expect(page).to have_content(bulk_discount_1.quantity_threshold)
        expect(page).to have_content(bulk_discount_2.percentage)
        expect(page).to have_content(bulk_discount_2.quantity_threshold)
        expect(page).not_to have_content(bulk_discount_3.percentage)
        expect(page).not_to have_content("For #{bulk_discount_3.quantity_threshold} or more items")
      end

      it 'i also see a link to each bulk_discount show page' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage: 20, quantity_threshold: 10)
        bulk_discount_2 = merchant_1.bulk_discounts.create!(percentage: 30, quantity_threshold: 15)

        merchant_2 = Merchant.create!(name: "John's Bars")
        bulk_discount_3 = merchant_2.bulk_discounts.create!(percentage: 50, quantity_threshold: 20)

        visit "/merchants/#{merchant_1.id}/bulk_discounts"

        within "#bulk_discount-#{bulk_discount_1.id}" do
          click_link "More Details"
        end

        expect(current_path).to eq("/merchants/#{merchant_1.id}/bulk_discounts/#{bulk_discount_1.id}")
      end

      it 'i see a link to create a new bulk_discount' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage: 20, quantity_threshold: 10)
        bulk_discount_2 = merchant_1.bulk_discounts.create!(percentage: 30, quantity_threshold: 15)

        visit "/merchants/#{merchant_1.id}/bulk_discounts"

        click_link "Create New Discount"

        expect(current_path).to eq("/merchants/#{merchant_1.id}/bulk_discounts/new")
      end

      it 'next to each bulk_discount i see a link to delete it, which when clicked,
          redirects me back to the index page where that bulk_discount is no longer listed' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage: 20, quantity_threshold: 10)
        bulk_discount_2 = merchant_1.bulk_discounts.create!(percentage: 30, quantity_threshold: 15)

        merchant_2 = Merchant.create!(name: "John's Bars")
        bulk_discount_3 = merchant_2.bulk_discounts.create!(percentage: 50, quantity_threshold: 25)

        visit "/merchants/#{merchant_1.id}/bulk_discounts"

        within "#bulk_discount-#{bulk_discount_1.id}" do
          click_button "Delete This Discount"
        end

        expect(current_path).to eq("/merchants/#{merchant_1.id}/bulk_discounts")

        expect(page).not_to have_content("20% off")
        expect(page).not_to have_content(bulk_discount_1.quantity_threshold)
        expect(page).to have_content(bulk_discount_2.percentage)
        expect(page).to have_content(bulk_discount_2.quantity_threshold)
        expect(page).not_to have_content(bulk_discount_3.percentage)
        expect(page).not_to have_content("For #{bulk_discount_3.quantity_threshold} or more items")
      end

      it 'i see an Upcoming Holidays section listing the name and date of the next 3 upcoming US holidays' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage: 20, quantity_threshold: 10)
        bulk_discount_2 = merchant_1.bulk_discounts.create!(percentage: 30, quantity_threshold: 15)

        merchant_2 = Merchant.create!(name: "John's Bars")
        bulk_discount_3 = merchant_2.bulk_discounts.create!(percentage: 50, quantity_threshold: 20)

        visit "/merchants/#{merchant_1.id}/bulk_discounts"

        within "#upcoming_holidays" do
          expect(page).to have_content("Upcoming Holidays")
          expect(page).to have_content("Memorial Day")
          expect(page).to have_content("2022-05-30")

          expect(page).to have_content("Juneteenth")
          expect(page).to have_content("2022-06-20")

          expect(page).to have_content("Independence Day")
          expect(page).to have_content("2022-07-04")
        end
      end
    end
  end
end
