require 'rails_helper'

RSpec.describe "Admin Invoices Index" do
  it 'displays a list of all Invoice IDs in the system' do
    bob = Customer.create!(first_name: "Bob", last_name: "Benson")
    invoice_1 = bob.invoices.create!(status: 1)
    invoice_2 = bob.invoices.create!(status: 1)
    invoice_3 = bob.invoices.create!(status: 1)
    invoice_4 = bob.invoices.create!(status: 1)
    invoice_5 = bob.invoices.create!(status: 1)

    visit '/admin/invoices'

    expect(page).to have_content("#{invoice_1.id}")
    expect(page).to have_content("#{invoice_2.id}")
    expect(page).to have_content("#{invoice_3.id}")
    expect(page).to have_content("#{invoice_4.id}")
    expect(page).to have_content("#{invoice_5.id}")
    click_link("#{invoice_1.id}")

    expect(current_path).to eq("/admin/invoices/#{invoice_1.id}")
  end
end
