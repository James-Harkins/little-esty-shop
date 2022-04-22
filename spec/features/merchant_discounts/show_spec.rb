RSpec.describe 'merchant_discounts index page' do
  describe 'as a user' do
    describe 'when i visit my discounts show page' do
      it 'i see all of my bulk discounts and their percentage and quantity thresholds' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 10)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 15)
        discount_3 = merchant_1.discounts.create!(percentage: 50, quantity_threshold: 35)

        visit "/merchants/#{merchant_1.id}/discounts/#{discount_1.id}"

        expect(page).to have_content("Buy 10 or more items and receive 20% off!")
        expect(page).not_to have_content("Buy 15 or more items and receive 30% off!")
        expect(page).not_to have_content("Buy 35 or more items and receive 50% off!")
      end

      it 'i see a link to edit the discount' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 10)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 15)
        discount_3 = merchant_1.discounts.create!(percentage: 50, quantity_threshold: 35)

        visit "/merchants/#{merchant_1.id}/discounts/#{discount_1.id}"

        click_link "Edit This Discount"

        expect(current_path).to eq("/merchants/#{merchant_1.id}/discounts/#{discount_1}/edit")
      end
    end
  end
end
