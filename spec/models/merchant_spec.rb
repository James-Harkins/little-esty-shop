require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items)}
    it { should have_many(:invoice_items).through(:items)}
    it { should have_many(:invoices).through(:invoice_items)}
    it { should have_many(:customers).through(:invoices)}
    it { should have_many(:transactions).through(:invoices)}
    it { should have_many(:discounts)}
  end

  describe 'instance methods' do
    describe '.most_popular_items' do
      it 'should return the 5 most popular items for some merchant in terms of
          total revenue generated' do
        merchant_1 = Merchant.create!(name: "Jim's Rare Guitars")
        item_1 = merchant_1.items.create!(name: "1959 Gibson Les Paul",
                                        description: "Tobacco Burst Finish, Rosewood Fingerboard",
                                        unit_price: 2500)
        item_2 = merchant_1.items.create!(name: "1954 Fender Stratocaster",
                                        description: "Seafoam Green Finish, Maple Fingerboard",
                                        unit_price: 1000)
        item_3 = merchant_1.items.create!(name: "1968 Gibson SG",
                                        description: "Cherry Red Finish, Rosewood Fingerboard",
                                        unit_price: 40)
        item_4 = merchant_1.items.create!(name: "1984 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 60)
        item_5 = merchant_1.items.create!(name: "1991 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 90)
        item_6 = merchant_1.items.create!(name: "1993 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 70)
        item_7 = merchant_1.items.create!(name: "2004 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 20)
        item_8 = merchant_1.items.create!(name: "1997 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 10)
        item_9 = merchant_1.items.create!(name: "1996 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 10)
        item_10 = merchant_1.items.create!(name: "1975 Gibson Les Paul",
                                        description: "Sunburst Finish, Maple Fingerboard",
                                        unit_price: 40)
        customer_1 = Customer.create!(first_name: "Guthrie", last_name: "Govan")
        invoice_1 = customer_1.invoices.create!(status: 1)
        invoice_2 = customer_1.invoices.create!(status: 0)
        invoice_3 = customer_1.invoices.create!(status: 1)
        invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, quantity: 1, unit_price: item_1.unit_price, status: 0)
        invoice_item_2 = InvoiceItem.create!(item: item_9, invoice: invoice_1, quantity: 25, unit_price: item_9.unit_price, status: 0)
        invoice_item_3 = InvoiceItem.create!(item: item_2, invoice: invoice_1, quantity: 1, unit_price: item_2.unit_price, status: 0)
        invoice_item_4 = InvoiceItem.create!(item: item_4, invoice: invoice_1, quantity: 31, unit_price: item_4.unit_price, status: 0)
        invoice_item_5 = InvoiceItem.create!(item: item_3, invoice: invoice_1, quantity: 35, unit_price: item_3.unit_price, status: 0)
        invoice_item_6 = InvoiceItem.create!(item: item_5, invoice: invoice_1, quantity: 10, unit_price: item_5.unit_price, status: 0)
        invoice_item_7 = InvoiceItem.create!(item: item_6, invoice: invoice_1, quantity: 17, unit_price: item_6.unit_price, status: 0)
        invoice_item_8 = InvoiceItem.create!(item: item_8, invoice: invoice_1, quantity: 22, unit_price: item_8.unit_price, status: 0)
        invoice_item_9 = InvoiceItem.create!(item: item_7, invoice: invoice_1, quantity: 1, unit_price: item_7.unit_price, status: 0)
        invoice_item_10 = InvoiceItem.create!(item: item_10, invoice: invoice_1, quantity: 4, unit_price: item_10.unit_price, status: 0)
        invoice_item_11 = InvoiceItem.create!(item: item_5, invoice: invoice_2, quantity: 10000, unit_price: item_5.unit_price, status: 0)
        invoice_item_12 = InvoiceItem.create!(item: item_7, invoice: invoice_2, quantity: 10000, unit_price: item_7.unit_price, status: 0)
        invoice_item_13 = InvoiceItem.create!(item: item_8, invoice: invoice_3, quantity: 10000, unit_price: item_8.unit_price, status: 0)
        transaction_1 = invoice_1.transactions.create!(credit_card_number: 0000111122223333, result: "success")
        transaction_2 = invoice_2.transactions.create!(credit_card_number: 0000111122223333, result: "failed")
        transaction_3 = invoice_3.transactions.create!(credit_card_number: 0000111122223333, result: "success")

        expect(merchant_1.most_popular_items).to eq([item_8, item_1, item_4, item_3, item_6])
      end

      describe '.distinct_invoices' do
        it 'returns all invoices that have any of the merchants items without duplicates' do
          merchant_1 = Merchant.create!(name: "Jim's Rare Guitars")
          item_1 = merchant_1.items.create!(name: "1959 Gibson Les Paul",
                                          description: "Tobacco Burst Finish, Rosewood Fingerboard",
                                          unit_price: 25000000)
          item_2 = merchant_1.items.create!(name: "1954 Fender Stratocaster",
                                          description: "Seafoam Green Finish, Maple Fingerboard",
                                          unit_price: 10000000)
          item_3 = merchant_1.items.create!(name: "1968 Gibson SG",
                                          description: "Cherry Red Finish, Rosewood Fingerboard",
                                          unit_price: 400000)
          merchant_2 = Merchant.create!(name: "Bob's Less Rare Guitars")
          item_4 = merchant_2.items.create!(name: "2006 Ibanez GX500",
                                            description: "Green Burst Finish, Rosewood Fingerboard",
                                            unit_price: 50000)
          item_5 = merchant_2.items.create!(name: "2013 ESP GH100",
                                            description: "Black Finish, Ebony Fingerboard",
                                            unit_price: 40000)
          customer_1 = Customer.create!(first_name: "Guthrie", last_name: "Govan")
          invoice_1 = customer_1.invoices.create!(status: 1)
          invoice_2 = customer_1.invoices.create!(status: 0)
          invoice_3 = customer_1.invoices.create!(status: 1)
          invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice_1, quantity: 1, unit_price: item_1.unit_price, status: 0)
          invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice_2, quantity: 25, unit_price: item_2.unit_price, status: 0)
          invoice_item_3 = InvoiceItem.create!(item: item_3, invoice: invoice_2, quantity: 1, unit_price: item_3.unit_price, status: 0)
          invoice_item_4 = InvoiceItem.create!(item: item_4, invoice: invoice_1, quantity: 31, unit_price: item_4.unit_price, status: 0)
          invoice_item_5 = InvoiceItem.create!(item: item_5, invoice: invoice_1, quantity: 35, unit_price: item_5.unit_price, status: 0)
          invoice_item_5 = InvoiceItem.create!(item: item_4, invoice: invoice_3, quantity: 35, unit_price: item_5.unit_price, status: 0)

          expect(merchant_1.distinct_invoices).to eq([invoice_1, invoice_2])
          expect(merchant_1.distinct_invoices.length).to eq(2)
        end
      end

      describe '.best_day' do
        it 'can determine the invoice date with the highest revenue' do
          date_1 = Time.parse("2016-07-25")
          date_2 = Time.parse("2022-04-05")
          date_3 = Time.parse("2018-09-01")
          merchant1 = Merchant.create!(name: "Merchant 1")
          merchant2 = Merchant.create!(name: "Merchant 2")
          item1 = merchant1.items.create(name: "Apple", description: "Let it rip!", unit_price: 1500)
          item2 = merchant2.items.create(name: "Coconut", description: "Let it rip!", unit_price: 700)
          bob = Customer.create!(first_name: "Bob", last_name: "Benson")
          dave = Customer.create!(first_name: "Dave", last_name: "Fogherty")
          invoice_1 = bob.invoices.create!(status: 1, created_at: date_1)
          invoice_2 = bob.invoices.create!(status: 1, created_at: date_2)
          invoice_3 = bob.invoices.create!(status: 1, created_at: date_2)
          invoice_4 = bob.invoices.create!(status: 1, created_at: date_3)
          invoice_5 = bob.invoices.create!(status: 1, created_at: date_3)
          invoice_item_1 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:21, unit_price: 1)
          invoice_item_2 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:10, unit_price: 1)
          invoice_item_3 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:13, unit_price: 1)
          invoice_item_4 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:2, unit_price: 1)
          invoice_item_5 = item1.invoice_items.create(invoice_id:invoice_2.id, quantity:1, unit_price: 1)
          invoice_item_6 = item1.invoice_items.create(invoice_id:invoice_2.id, quantity:50, unit_price: 1)
          invoice_item_7 = item1.invoice_items.create(invoice_id:invoice_2.id, quantity:1, unit_price: 1)
          invoice_item_8 = item1.invoice_items.create(invoice_id:invoice_2.id, quantity:1, unit_price: 1)
          invoice_item_9 = item1.invoice_items.create(invoice_id:invoice_2.id, quantity:1, unit_price: 1)
          invoice_item_10 = item2.invoice_items.create(invoice_id:invoice_3.id, quantity:8, unit_price: 1)
          invoice_item_11 = item2.invoice_items.create(invoice_id:invoice_3.id, quantity:150000, unit_price: 1)
          invoice_item_12 = item2.invoice_items.create(invoice_id:invoice_3.id, quantity:1, unit_price: 1)
          invoice_item_12 = item1.invoice_items.create(invoice_id:invoice_4.id, quantity:30, unit_price: 1)
          invoice_item_12 = item1.invoice_items.create(invoice_id:invoice_5.id, quantity:30, unit_price: 1)
          transactions_1 = invoice_1.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_2 = invoice_2.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_3 = invoice_3.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          expect(merchant1.best_day).to eq(date_3)
        end
      end
    end
  end
  describe 'class methods' do
    describe '.top_five_by_revenue' do
      it "top five by revenue finds top five by revenue" do
          merchant1 = Merchant.create(name: "Merchant 1")
          merchant2 = Merchant.create(name: "Merchant 2")
          merchant3 = Merchant.create(name: "Merchant 3")
          merchant4 = Merchant.create(name: "Merchant 4")
          merchant5 = Merchant.create(name: "Merchant 5")
          merchant6 = Merchant.create(name: "Merchant 6")
          merchant7 = Merchant.create(name: "Merchant 7")

          item1 = merchant1.items.create(name: "Apple", description: "Let it rip!", unit_price: 1500)
          item2 = merchant1.items.create(name: "Banana", description: "Let it rip!", unit_price: 2000)
          item3 = merchant2.items.create(name: "Coconut", description: "Let it rip!", unit_price: 700)
          item4 = merchant3.items.create(name: "Date", description: "Let it rip!", unit_price: 123)
          item5 = merchant4.items.create(name: "Eggplant", description: "Let it rip!", unit_price: 500)
          item6 = merchant5.items.create(name: "Fennel", description: "Let it rip!", unit_price: 60)
          item7 = merchant6.items.create(name: "Grape", description: "Let it rip!", unit_price: 10)
          item8 = merchant7.items.create(name: "Habenero", description: "Let it rip!", unit_price: 325)

          bob = Customer.create!(first_name: "Bob", last_name: "Benson")
          dave = Customer.create!(first_name: "Dave", last_name: "Fogherty")

          invoice_1 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
          invoice_2 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
          invoice_3 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
          invoice_4 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
          invoice_5 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
          invoice_6 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
          invoice_7 = bob.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
          invoice_8 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
          invoice_9 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
          invoice_10 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
          invoice_11 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')
          invoice_12 = dave.invoices.create!(status: 1, created_at: '05 Apr 2022 00:53:36 UTC +00:00')

          invoice_item_1 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:21, unit_price: 1500)
          invoice_item_2 = item2.invoice_items.create(invoice_id:invoice_1.id, quantity:10, unit_price: 2000)
          invoice_item_3 = item3.invoice_items.create(invoice_id:invoice_1.id, quantity:13, unit_price: 700)
          invoice_item_4 = item4.invoice_items.create(invoice_id:invoice_1.id, quantity:2, unit_price: 123)
          invoice_item_5 = item5.invoice_items.create(invoice_id:invoice_1.id, quantity:9, unit_price: 500)
          invoice_item_6 = item6.invoice_items.create(invoice_id:invoice_1.id, quantity:19, unit_price: 60)
          invoice_item_7 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:12, unit_price: 10)
          invoice_item_8 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:11, unit_price: 1500)
          invoice_item_9 = item1.invoice_items.create(invoice_id:invoice_1.id, quantity:10, unit_price: 1500)
          invoice_item_10 = item2.invoice_items.create(invoice_id:invoice_1.id, quantity:8, unit_price: 2000)
          invoice_item_11 = item2.invoice_items.create(invoice_id:invoice_1.id, quantity:31, unit_price: 2000)
          invoice_item_12 = item3.invoice_items.create(invoice_id:invoice_1.id, quantity:1, unit_price: 700)

          transactions_1 = invoice_1.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_2 = invoice_2.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_3 = invoice_3.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_4 = invoice_4.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_5 = invoice_5.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_6 = invoice_6.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_7 = invoice_7.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_8 = invoice_8.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_9 = invoice_9.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_10 = invoice_10.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_11 = invoice_11.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )
          transactions_12 = invoice_12.transactions.create(credit_card_number: "*", credit_card_expiration_date: "*", result:"success" )

          merchant = Merchant.top_five_by_revenue
          expect(merchant[0].name).to eq('Merchant 1')
          expect(merchant[1].name).to eq('Merchant 2')
          expect(merchant[2].name).to eq('Merchant 4')
          expect(merchant[3].name).to eq('Merchant 5')
          expect(merchant[4].name).to eq('Merchant 3')
      end
    end
  end
end
