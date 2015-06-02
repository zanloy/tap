require 'rails_helper'

RSpec.describe Purchase, type: :model do
  it 'creates a valid object' do
    expect(build(:purchase)).to be_valid
  end

  it 'is invalid without a ticket' do
    expect(build(:purchase, ticket: nil)).to be_invalid
  end

  it 'is invalid without a name' do
    expect(build(:purchase, name: nil)).to be_invalid
  end

  it 'is invalid without a quantity' do
    expect(build(:purchase, quantity: nil)).to be_invalid
  end

  it 'is invalid without a cost' do
    expect(build(:purchase, cost: nil)).to be_invalid
  end

  describe '#total' do
    it 'returns the total cost' do
      expect(build(:purchase, quantity: 2, cost: 2.50).total).to eq(5)
    end
  end

  describe '#has_url?' do
    it 'return true if url exists' do
      expect(build(:purchase, url: 'http://amazon.com').has_url?).to eq(true)
    end
    it 'return false if no url exists' do
      expect(build(:purchase, url: nil).has_url?).to eq(false)
    end
  end
end
