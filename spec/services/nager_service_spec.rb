require 'rails_helper'

RSpec.describe NagerService do
  describe 'get_url' do
    it 'returns an array of hashes made from the returned JSON object' do
      service = NagerService.new

      test = service.get_url("https://date.nager.at/api/v3/NextPublicHolidays/us")

      expect(test).to be_a(Array)
      expect(test[0]).to be_a(Hash)
    end
  end

  describe 'get_holidays' do
    it 'returns holiday data' do
      service = NagerService.new

      test = service.get_url("https://date.nager.at/api/v3/NextPublicHolidays/us")

      expect(test[0][:localName]).to be_a(String)
      expect(test[0][:date]).to be_a(String)
    end
  end
end
