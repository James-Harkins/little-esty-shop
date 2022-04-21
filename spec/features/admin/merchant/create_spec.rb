require 'rails_helper'

RSpec.describe 'the admin merchant create page' do
  it 'has a link to create new merchant on index page' do
    merchant_1 = Merchant.create!(name: "Mollys", status: 1)

    visit admin_merchants_path

    expect(page).to have_link("Create New Merchant")
  end

  it 'has a form which can add merchant info' do
    merchant_1 = Merchant.create!(name: "Mollys", status: 1)

    visit admin_merchants_path

    click_link "Create New Merchant"
    fill_in :name, with: "Bobby Sues"
    click_button 'Submit'

    expect(current_path).to eq(admin_merchants_path)
    expect(page).to have_content("Bobby Sues")
  end

  it 'the default status for a new merchant is disabled' do
    merchant_1 = Merchant.create!(name: "Mollys")

    expect(merchant_1.status).to eq('disabled')
  end
end
