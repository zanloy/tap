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
    it 'returns false' do
      expect(build(:ticket).has_purchases?).to eq(false)
    end

    it 'returns true' do
      ticket = create(:ticket_with_purchases)
      expect(ticket.has_purchases?).to eq(true)
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

  describe '.state' do
    context 'without purchases' do
      before(:all) do
        @user = create(:user)
        @ticket = create(:ticket)
      end

      it 'starts :unassigned' do
        expect(@ticket.state_name).to eql(:unassigned)
      end

      it '#assign_to transitions to :assigned' do
        @ticket.assign_to(@user)
        expect(@ticket.state_name).to eql(:assigned)
      end

      it '#close transitions to :closed' do
        @ticket.close(@user)
        expect(@ticket.state_name).to eql(:closed)
      end

      it '#reopen re-opens the ticket' do
        @ticket.reopen
        expect(@ticket.state_name).to eql(:assigned)
      end
    end

    context 'with purchases' do
      before(:all) do
        @user = create(:user)
        @ticket = create(:ticket_with_purchases)
      end

      it 'starts :awaiting_manager' do
        expect(@ticket.state_name).to eql(:awaiting_manager)
      end

      it 'transitions to :awaiting_executive' do
        @ticket.manager_approve(@user)
        expect(@ticket.state_name).to eql(:awaiting_executive)
      end

      it 'transitions to :closed' do
        @ticket.executive_approve(@user)
        expect(@ticket.state_name).to eql(:closed)
      end

      it '#archive archives the ticket' do
        @ticket.archive
        expect(@ticket.state_name).to eql(:archived)
      end
    end

    describe '#manager_approved?' do
      before(:each) do
        @user = create(:user)
        @ticket = create(:ticket_with_purchases)
      end

      it 'returns false' do
        expect(@ticket.manager_approved?).to eql(false)
      end

      it 'returns true' do
        @ticket.manager_approve(@user)
        expect(@ticket.manager_approved?).to eql(true)
      end
    end

    describe '#executive_approved?' do
      before(:each) do
        @user = create(:user)
        @ticket = create(:ticket_with_purchases)
      end

      it 'return false' do
        expect(@ticket.executive_approved?).to eql(false)
      end

      it 'returns true' do
        @ticket.executive_approve(@user)
        expect(@ticket.executive_approved?).to eql(true)
      end
    end

    describe '#flag_color' do
      before(:all) { @ticket = build(:ticket) }

      it 'returns :red' do
        @ticket.priority = Ticket::PRIORITIES.index('urgent')
        expect(@ticket.flag_color).to eql('red')
      end

      it 'returns :yellow' do
        @ticket.priority = Ticket::PRIORITIES.index('normal')
        expect(@ticket.flag_color).to eql('yellow')
      end

      it 'returns :blue' do
        @ticket.priority = Ticket::PRIORITIES.index('low')
        expect(@ticket.flag_color).to eql('blue')
      end

      it 'returns :navy' do
        @ticket.state = :archived
        expect(@ticket.flag_color).to eql('navy')
      end

      it 'returns :green' do
        @ticket.state = :closed
        expect(@ticket.flag_color).to eql('green')
      end

    end
  end
end
