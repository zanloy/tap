require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it 'creates a valid object' do
    expect(build(:ticket)).to be_valid
  end

  it 'is invalid without project' do
    expect(build(:ticket, project: nil)).to be_invalid
  end

  it 'is invalid without a reporter' do
    expect(build(:ticket, reporter: nil)).to be_invalid
  end

  it 'is invalid without a title' do
    expect(build(:ticket, title: nil)).to be_invalid
  end

  describe '#priority_name' do
    it 'returns human readable priority' do
      expect(build(:ticket, priority: 1).priority_name).to eq('Normal')
    end
  end

  describe 'has_purchases?' do
    it 'returns true if purchases exist' do
      ticket = create(:ticket_with_purchases)
      expect(ticket.has_purchases?).to eq(true)
    end

    it 'returns false if no purchases exist' do
      expect(build(:ticket).has_purchases?).to eq(false)
    end
  end

  describe '#total_items' do
    it 'returns the total of purchase items' do
      ticket = create(:ticket)
      create(:purchase, ticket: ticket, quantity: 2)
      expect(ticket.total_items).to eq(2)
    end
  end

  describe '#total_cost' do
    it 'returns the of all purchase items' do
      ticket = create(:ticket)
      create(:purchase, ticket: ticket, quantity: 1, cost: 1.5)
      create(:purchase, ticket: ticket, quantity: 2, cost: 2.5)
      expect(ticket.total_cost).to eq(6.5)
    end
  end
end
