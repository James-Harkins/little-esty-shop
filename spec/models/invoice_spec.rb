require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer)}
    it { should have_many(:transactions)}
    it { should have_many(:invoice_items)}
    it { should have_many(:items).through(:invoice_items)}
    it { should have_many(:merchants).through(:items)}
  end

  describe 'class methods' do
    it '#incomplete' do
      walmart = Merchant.create!(name: "Wal-Mart")
      bob = Customer.create!(first_name: "Bob", last_name: "Benson")
      item_1 = walmart.items.create!(name: "pickle", description: "sour cucumber", unit_price: 300)
      item_2 = walmart.items.create!(name: "eraser", description: "rubber bit", unit_price: 200)
      item_3 = walmart.items.create!(name: "candle", description: "beeswax", unit_price: 1000)
      item_4 = walmart.items.create!(name: "calculator", description: "scientific", unit_price: 2000)
      item_5 = walmart.items.create!(name: "ball", description: "soccer", unit_price: 900)
      item_6 = walmart.items.create!(name: "notebook", description: "leatherbound", unit_price: 2500)
      item_7 = walmart.items.create!(name: "wine glass", description: "stemless", unit_price: 350)
      item_8 = walmart.items.create!(name: "banjo", description: "five string", unit_price: 30100)
      item_9 = walmart.items.create!(name: "golf tees", description: "2 1/2 inch", unit_price: 100)
      item_10 = walmart.items.create!(name: "radio", description: "AM/FM", unit_price: 900)
      item_11 = walmart.items.create!(name: "adult diaper", description: "family size", unit_price: 400)
      invoice_1 = bob.invoices.create!(status: 1)
      invoice_2 = bob.invoices.create!(status: 1)
      invoice_3 = bob.invoices.create!(status: 1)
      invoice_4 = bob.invoices.create!(status: 1)
      invoice_5 = bob.invoices.create!(status: 1)
      invoice_6 = bob.invoices.create!(status: 1)
      invoice_7 = bob.invoices.create!(status: 1)
      invoice_8 = bob.invoices.create!(status: 1)
      invoice_9 = bob.invoices.create!(status: 1)
      invoice_10 = bob.invoices.create!(status: 1)
      invoice_11 = bob.invoices.create!(status: 1)
      InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, status: 1)
      InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_3.id, item_id: item_3.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_4.id, item_id: item_4.id, quantity: 1, status: 0)
      InvoiceItem.create!(invoice_id: invoice_5.id, item_id: item_5.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_6.id, item_id: item_6.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_7.id, item_id: item_7.id, quantity: 1, status: 1)
      InvoiceItem.create!(invoice_id: invoice_8.id, item_id: item_8.id, quantity: 1, status: 0)
      InvoiceItem.create!(invoice_id: invoice_9.id, item_id: item_9.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_10.id, item_id: item_10.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_11.id, item_id: item_11.id, quantity: 1, status: 2)

      expect(Invoice.incomplete).to eq([invoice_1, invoice_4, invoice_7, invoice_8])
    end

    it '#sorted_by_newest' do
      walmart = Merchant.create!(name: "Wal-Mart")
      bob = Customer.create!(first_name: "Bob", last_name: "Benson")
      item_1 = walmart.items.create!(name: "pickle", description: "sour cucumber", unit_price: 300)
      item_2 = walmart.items.create!(name: "eraser", description: "rubber bit", unit_price: 200)
      item_3 = walmart.items.create!(name: "candle", description: "beeswax", unit_price: 1000)
      item_4 = walmart.items.create!(name: "calculator", description: "scientific", unit_price: 2000)
      item_5 = walmart.items.create!(name: "ball", description: "soccer", unit_price: 900)
      item_6 = walmart.items.create!(name: "notebook", description: "leatherbound", unit_price: 2500)
      item_7 = walmart.items.create!(name: "wine glass", description: "stemless", unit_price: 350)
      item_8 = walmart.items.create!(name: "banjo", description: "five string", unit_price: 30100)
      item_9 = walmart.items.create!(name: "golf tees", description: "2 1/2 inch", unit_price: 100)
      item_10 = walmart.items.create!(name: "radio", description: "AM/FM", unit_price: 900)
      item_11 = walmart.items.create!(name: "adult diaper", description: "family size", unit_price: 400)
      invoice_1 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
      invoice_2 = bob.invoices.create!(status: 1, created_at: '04 Apr 2022 00:53:36 UTC +00:00')
      invoice_3 = bob.invoices.create!(status: 1, created_at: '03 Apr 2022 00:53:36 UTC +00:00')
      invoice_4 = bob.invoices.create!(status: 1, created_at: '02 Apr 2022 00:53:36 UTC +00:00')
      invoice_5 = bob.invoices.create!(status: 1, created_at: '01 Apr 2022 00:53:36 UTC +00:00')
      invoice_6 = bob.invoices.create!(status: 1, created_at: '06 Apr 2022 00:53:36 UTC +00:00')
      invoice_7 = bob.invoices.create!(status: 1, created_at: '07 Apr 2022 00:53:36 UTC +00:00')
      invoice_8 = bob.invoices.create!(status: 1, created_at: '08 Apr 2022 00:53:36 UTC +00:00')
      invoice_9 = bob.invoices.create!(status: 1, created_at: '09 Apr 2022 00:53:36 UTC +00:00')
      invoice_10 = bob.invoices.create!(status: 1, created_at: '10 Apr 2022 00:53:36 UTC +00:00')
      invoice_11 = bob.invoices.create!(status: 1, created_at: '11 Apr 2022 00:53:36 UTC +00:00')
      InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, status: 1)
      InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_3.id, item_id: item_3.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_4.id, item_id: item_4.id, quantity: 1, status: 0)
      InvoiceItem.create!(invoice_id: invoice_5.id, item_id: item_5.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_6.id, item_id: item_6.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_7.id, item_id: item_7.id, quantity: 1, status: 1)
      InvoiceItem.create!(invoice_id: invoice_8.id, item_id: item_8.id, quantity: 1, status: 0)
      InvoiceItem.create!(invoice_id: invoice_9.id, item_id: item_9.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_10.id, item_id: item_10.id, quantity: 1, status: 2)
      InvoiceItem.create!(invoice_id: invoice_11.id, item_id: item_11.id, quantity: 1, status: 2)

      expect(Invoice.sorted_by_newest.take(5)).to eq([invoice_11, invoice_10, invoice_9, invoice_8, invoice_7])
    end
  end

  describe 'instance methods' do
    describe '.total_revenue' do
      it 'returns the total revenue of some invoice before applying discounts' do
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
        item_6 = merchant_1.items.create!(name: "1993 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 700)
        item_7 = merchant_1.items.create!(name: "2004 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 200)
        item_8 = merchant_1.items.create!(name: "1997 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 100)
        item_9 = merchant_1.items.create!(name: "1996 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 100)
        item_10 = merchant_1.items.create!(name: "1975 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 400)
        customer_1 = Customer.create!(first_name: "Guthrie", last_name: "Govan")

        invoice_1 = customer_1.invoices.create!(status: 1)
        invoice_2 = customer_1.invoices.create!(status: 0)
        invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, quantity: 1, unit_price: 5, status: 0)
        invoice_item_2 = InvoiceItem.create!(item: item_9, invoice: invoice_1, quantity: 20, unit_price: 10, status: 0)
        invoice_item_3 = InvoiceItem.create!(item: item_2, invoice: invoice_1, quantity: 10, unit_price: 20, status: 0)
        invoice_item_4 = InvoiceItem.create!(item: item_4, invoice: invoice_1, quantity: 30, unit_price: 5, status: 0)
        invoice_item_5 = InvoiceItem.create!(item: item_3, invoice: invoice_1, quantity: 35, unit_price: 10, status: 0)
        invoice_item_6 = InvoiceItem.create!(item: item_5, invoice: invoice_1, quantity: 10, unit_price: 25, status: 0)
        invoice_item_7 = InvoiceItem.create!(item: item_6, invoice: invoice_1, quantity: 5, unit_price: 10, status: 0)
        invoice_item_8 = InvoiceItem.create!(item: item_8, invoice: invoice_1, quantity: 10, unit_price: 15, status: 0)
        invoice_item_9 = InvoiceItem.create!(item: item_7, invoice: invoice_1, quantity: 1, unit_price: 5, status: 0)
        invoice_item_10 = InvoiceItem.create!(item: item_10, invoice: invoice_1, quantity: 4, unit_price: 20, status: 0)
        invoice_item_11 = InvoiceItem.create!(item: item_5, invoice: invoice_2, quantity: 10000, unit_price: 25, status: 0)
        invoice_item_12 = InvoiceItem.create!(item: item_7, invoice: invoice_2, quantity: 10000, unit_price: 50, status: 0)
        invoice_item_13 = InvoiceItem.create!(item: item_8, invoice: invoice_1, quantity: 10000, unit_price: 20, status: 0)
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 20)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 40)

        expect(invoice_1.total_revenue).to eq(1440)
      end
    end

    describe '.discounted_revenue' do
      it 'returns the revenue of some invoice including discounts' do
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
        item_6 = merchant_1.items.create!(name: "1993 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 700)
        item_7 = merchant_1.items.create!(name: "2004 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 200)
        item_8 = merchant_1.items.create!(name: "1997 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 100)
        item_9 = merchant_1.items.create!(name: "1996 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 100)
        item_10 = merchant_1.items.create!(name: "1975 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 400)
        customer_1 = Customer.create!(first_name: "Guthrie", last_name: "Govan")

        invoice_1 = customer_1.invoices.create!(status: 1)
        invoice_2 = customer_1.invoices.create!(status: 0)
        invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, quantity: 1, unit_price: 5, status: 0)
        invoice_item_2 = InvoiceItem.create!(item: item_9, invoice: invoice_1, quantity: 20, unit_price: 10, status: 0)
        invoice_item_3 = InvoiceItem.create!(item: item_2, invoice: invoice_1, quantity: 10, unit_price: 20, status: 0)
        invoice_item_4 = InvoiceItem.create!(item: item_4, invoice: invoice_1, quantity: 30, unit_price: 5, status: 0)
        invoice_item_5 = InvoiceItem.create!(item: item_3, invoice: invoice_1, quantity: 35, unit_price: 10, status: 0)
        invoice_item_6 = InvoiceItem.create!(item: item_5, invoice: invoice_1, quantity: 10, unit_price: 25, status: 0)
        invoice_item_7 = InvoiceItem.create!(item: item_6, invoice: invoice_1, quantity: 5, unit_price: 10, status: 0)
        invoice_item_8 = InvoiceItem.create!(item: item_8, invoice: invoice_1, quantity: 10, unit_price: 15, status: 0)
        invoice_item_9 = InvoiceItem.create!(item: item_7, invoice: invoice_1, quantity: 1, unit_price: 5, status: 0)
        invoice_item_10 = InvoiceItem.create!(item: item_10, invoice: invoice_1, quantity: 4, unit_price: 20, status: 0)
        invoice_item_11 = InvoiceItem.create!(item: item_5, invoice: invoice_2, quantity: 10000, unit_price: 25, status: 0)
        invoice_item_12 = InvoiceItem.create!(item: item_7, invoice: invoice_2, quantity: 10000, unit_price: 50, status: 0)
        invoice_item_13 = InvoiceItem.create!(item: item_8, invoice: invoice_1, quantity: 10000, unit_price: 20, status: 0)
        discount_1 = merchant_1.discounts.create!(percentage: 20, quantity_threshold: 20)
        discount_2 = merchant_1.discounts.create!(percentage: 30, quantity_threshold: 40)

        expect(invoice_1.discounted_revenue).to eq(1200)
      end
    end
  end
end
