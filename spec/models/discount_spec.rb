require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it { should validate_presence_of :percentage }
    it { should allow_value(1).for(:percentage)}
    it { should allow_value(50).for(:percentage)}
    it { should allow_value(99).for(:percentage)}
    it { should_not allow_value(100).for(:percentage)}
    it { should_not allow_value(200).for(:percentage)}
    it { should_not allow_value(500).for(:percentage)}
    it { should_not allow_value(-50).for(:percentage)}
    it { should_not allow_value(25.5).for(:percentage)}
    it { should validate_presence_of :quantity_threshold }
    it { should allow_value(10).for(:quantity_threshold)}
    it { should allow_value(500).for(:quantity_threshold)}
    it { should_not allow_value(1).for(:quantity_threshold)}
  end
end
