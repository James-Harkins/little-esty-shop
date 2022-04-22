RSpec.describe 'merchant_discounts edit page' do
  describe 'as a user' do
    describe 'when i visit my discounts edit page' do
      it 'i see a form to edit the discount with its attributes pre-populated' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 10)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 15)
        discount_3 = merchant_1.discounts.create!(percentage: 50, quantity_threshold: 35)

        visit "/merchants/#{merchant_1.id}/discounts/#{discount_1.id}/edit"

        expect(page).to have_field("Percentage", with: discount_1.percentage)
        expect(page).to have_field("Quantity threshold", with: discount_1.quantity_threshold)
      end

      it 'when i change all of the info and click submit, i am redirected
          back to the discounts show page and i see that the info has been updated' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 10)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 15)
        discount_3 = merchant_1.discounts.create!(percentage: 50, quantity_threshold: 35)

        visit "/merchants/#{merchant_1.id}/discounts/#{discount_1.id}/edit"

        fill_in "Percentage", with: 10
        fill_in "Quantity threshold", with: 5

        click_button "Submit"

        expect(current_path).to eq("/merchants/#{merchant_1.id}/discounts/#{discount_1.id}")

        expect(page).to have_content("Buy 5 or more items and receive 10% off!")
        expect(page).not_to have_content("Buy 10 or more items and receive 20% off!")
      end

      it 'if i input invalid data, then i am redirected back to the edit page with a flash
          message telling me what type of data is valid' do
        merchant_1 = Merchant.create!(name: "Jim's Plates")
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 10)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 15)
        discount_3 = merchant_1.discounts.create!(percentage: 50, quantity_threshold: 35)

        visit "/merchants/#{merchant_1.id}/discounts/#{discount_1.id}/edit"

        fill_in :percentage, with: 200
        fill_in :quantity_threshold, with: 1

        click_button 'Submit'

        expect(page).to have_content("Invalid Data: Percentage must be a whole number between 1 and 99 and Quantity Threshold must be a whole number greater than 1")

        fill_in :percentage, with: 99
        fill_in :quantity_threshold, with: 1

        click_button 'Submit'

        expect(page).to have_content("Invalid Data: Percentage must be a whole number between 1 and 99 and Quantity Threshold must be a whole number greater than 1")

        fill_in "Percentage", with: 10
        fill_in "Quantity threshold", with: 5

        click_button "Submit"

        expect(current_path).to eq("/merchants/#{merchant_1.id}/discounts/#{discount_1.id}")

        expect(page).to have_content("Buy 5 or more items and receive 10% off!")
        expect(page).not_to have_content("Buy 10 or more items and receive 20% off!")
      end
    end
  end
end
