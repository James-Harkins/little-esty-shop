require 'rails_helper'

RSpec.describe 'the Admin Merchant Update page' do
  before :each do
    @merchant_1 = Merchant.create!(name: "Mollys")
    @merchant_2 = Merchant.create!(name: "Berrys")
  end

  it 'takes me to the edit page for the merchant' do
    visit "/admin/merchants/#{@merchant_1.id}"

    expect(page).to have_content("Update Merchant Information")
    expect(page).to have_content("#{@merchant_1.name}")
    expect(page).to_not have_content("#{@merchant_2.name}")
  end

  it 'goes to the edit page form which has current merchant attributes' do
    visit "/admin/merchants/#{@merchant_1.id}"

    click_link "Update Merchant Information"

    expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}/edit")
  end

  it 'updates the information and reroutes to admin merch show' do
    visit "/admin/merchants/#{@merchant_1.id}"

    click_link "Update Merchant Information"

    fill_in 'Name', with: "Not Mollys Anymore"

    click_button 'Save'

    expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}")

    expect(page).to have_content("Not Mollys Anymore")
    expect(page).to have_content("Information Successfully Updated")
  end
end
