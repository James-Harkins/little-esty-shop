require 'rails_helper'

RSpec.describe HolidayFacade do
  describe 'service' do
    it 'returns a NagerService object' do
      facade = HolidayFacade.new

      expect(facade.service).to be_a(NagerService)
    end
  end

  describe 'holiday_data' do
    it 'returns holiday data' do
      facade = HolidayFacade.new

      test = facade.holiday_data

      expect(test[0][:localName]).to be_a(String)
      expect(test[0][:date]).to be_a(String)
    end
  end

  describe 'next_three_holidays' do
    it 'creates 3 holiday objects for the first three holidays listed in the API data' do
      facade = HolidayFacade.new

      holidays = facade.next_three_holidays

      expect(holidays.count).to eq(3)
      expect(holidays[1]).to be_a(Holiday)
    end
  end
end
