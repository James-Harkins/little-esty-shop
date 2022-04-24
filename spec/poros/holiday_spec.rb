require 'rails_helper'

RSpec.describe Holiday do
  describe 'attributes' do
    it 'has a name and a date' do
      data = {name: "Independence Day", date: "2022-07-04"}
      july_fourth = Holiday.new(data)

      expect(july_fourth.name).to eq("Independence Day")
      expect(july_fourth.date).to eq("2022-07-04")
    end
  end
end
