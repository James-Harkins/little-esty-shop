RSpec.describe 'merchant_discounts index page' do
  describe 'as a user' do
    describe 'when i visit my discounts index page' do
      it 'i see all of my bulk discounts and their percentage and quantity thresholds' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 10)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 15)
        discount_3 = merchant_1.discounts.create!(percentage: 50, quantity_threshold: 35)

        visit "/merchants/#{merchant_1.id}/discounts/#{discount_1.id}"

        expect(page).to have_content("Buy 20 or more items and receive 10% off!")
        expect(page).not_to have_content("Buy 30 or more items and receive 15% off!")
        expect(page).not_to have_content("Buy 50 or more items and receive 35% off!")
      end
    end
  end
end
