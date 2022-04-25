RSpec.describe 'merchant_bulk_discounts show page' do
  describe 'as a user' do
    describe 'when i visit a bulk_discounts show page' do
      it 'i see only that bulk bulk_discount and its percentage and quantity thresholds' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage: 20, quantity_threshold: 10)
        bulk_discount_2 = merchant_1.bulk_discounts.create!(percentage: 30, quantity_threshold: 15)
        bulk_discount_3 = merchant_1.bulk_discounts.create!(percentage: 50, quantity_threshold: 35)

        visit "/merchants/#{merchant_1.id}/bulk_discounts/#{bulk_discount_1.id}"

        expect(page).to have_content("Buy 10 or more items and receive 20% off!")
        expect(page).not_to have_content("Buy 15 or more items and receive 30% off!")
        expect(page).not_to have_content("Buy 35 or more items and receive 50% off!")
      end

      it 'i see a link to edit the bulk_discount' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        bulk_discount_1 = merchant_1.bulk_discounts.create!(percentage: 20, quantity_threshold: 10)
        bulk_discount_2 = merchant_1.bulk_discounts.create!(percentage: 30, quantity_threshold: 15)
        bulk_discount_3 = merchant_1.bulk_discounts.create!(percentage: 50, quantity_threshold: 35)

        visit "/merchants/#{merchant_1.id}/bulk_discounts/#{bulk_discount_1.id}"

        click_link "Edit This Discount"

        expect(current_path).to eq("/merchants/#{merchant_1.id}/bulk_discounts/#{bulk_discount_1.id}/edit")
      end
    end
  end
end
