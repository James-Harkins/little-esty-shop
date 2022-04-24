require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
    it { should have_one(:merchant).through(:item)}
    it { should have_many(:discounts).through(:merchant)}
  end

  describe 'class methods' do
    it '#total_revenue' do
      walmart = Merchant.create!(name: "Wal-Mart")
      bob = Customer.create!(first_name: "Bob", last_name: "Benson")
      item_1 = walmart.items.create!(name: "pickle", description: "sour cucumber", unit_price: 300)
      item_2 = walmart.items.create!(name: "eraser", description: "rubber bit", unit_price: 200)

      invoice_1 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')

      InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 6, status: 1, unit_price: 295)
      InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 2, status: 0, unit_price: 215)

      expect(InvoiceItem.total_revenue).to eq(2200)
    end
  end

  describe 'instance methods' do
    describe '.apply_discount' do
      it 'can determine if an invoice meets the threshold for any discounts and applies the highest available discount' do
        merchant_1 = Merchant.create!(name: "Jim's Rare Guitars")
        item_1 = merchant_1.items.create!(name: "1959 Gibson Les Paul",
                                        description: "Tobacco Burst Finish, Rosewood Fingerboard",
                                        unit_price: 25000)
        item_2 = merchant_1.items.create!(name: "1954 Fender Stratocaster",
                                        description: "Seafoam Green Finish, Maple Fingerboard",
                                        unit_price: 10000)
        item_3 = merchant_1.items.create!(name: "1968 Gibson SG",
                                        description: "Cherry Red Finish, Rosewood Fingerboard",
                                        unit_price: 400)
        item_4 = merchant_1.items.create!(name: "1984 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 600)
        item_5 = merchant_1.items.create!(name: "1991 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 900)
        customer_1 = Customer.create!(first_name: "Guthrie", last_name: "Govan")
        invoice_1 = customer_1.invoices.create!(status: 1)
        invoice_2 = customer_1.invoices.create!(status: 0)
        invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, quantity: 1, unit_price: 5, status: 0)
        invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice_1, quantity: 20, unit_price: 10, status: 0)
        invoice_item_3 = InvoiceItem.create!(item: item_3, invoice: invoice_1, quantity: 10, unit_price: 20, status: 0)
        invoice_item_4 = InvoiceItem.create!(item: item_4, invoice: invoice_1, quantity: 30, unit_price: 5, status: 0)
        invoice_item_5 = InvoiceItem.create!(item: item_5, invoice: invoice_1, quantity: 35, unit_price: 10, status: 0)
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 20)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 40)

        invoice_item_1.apply_discount
        invoice_item_2.apply_discount
        invoice_item_3.apply_discount
        invoice_item_4.apply_discount
        invoice_item_5.apply_discount

        expect(invoice_item_1.discount_percentage).to eq(100)
        expect(invoice_item_2.discount_percentage).to eq(80)
        expect(invoice_item_3.discount_percentage).to eq(100)
        expect(invoice_item_4.discount_percentage).to eq(60)
        expect(invoice_item_5.discount_percentage).to eq(60)
      end
    end
  end
end
