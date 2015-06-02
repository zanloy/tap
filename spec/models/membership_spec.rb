require 'rails_helper'

RSpec.describe Membership, type: :model do
  it 'creates a valid object' do
    expect(build(:membership)).to be_valid
  end

  it 'is invalid without a project' do
    expect(build(:membership, project: nil)).to be_invalid
  end

  it 'is invalid without a user' do
    expect(build(:membership, user: nil)).to be_invalid
  end

  describe '#role?' do
    context 'worker role' do
      it 'not for member' do
        expect(build(:membership).role? :worker).to eq(false)
      end
      it 'for worker' do
        expect(build(:membership, :worker).role? :worker).to eq(true)
      end
      it 'for moderator' do
        expect(build(:membership, :moderator).role? :worker).to eq(true)
      end
      it 'for manager' do
        expect(build(:membership, :manager).role? :worker).to eq(true)
      end
    end

    context 'moderator role' do
      it 'not for member' do
        expect(build(:membership).role? :moderator).to eq(false)
      end
      it 'not for worker' do
        expect(build(:membership, :worker).role? :moderator).to eq(false)
      end
      it 'for moderator' do
        expect(build(:membership, :moderator).role? :moderator).to eq(true)
      end
      it 'for manager' do
        expect(build(:membership, :manager).role? :moderator).to eq(true)
      end
    end

    context 'manager role' do
      it 'not for member' do
        expect(build(:membership).role? :manager).to eq(false)
      end
      it 'not for worker' do
        expect(build(:membership, :worker).role? :manager).to eq(false)
      end
      it 'not for moderator' do
        expect(build(:membership, :moderator).role? :manager).to eq(false)
      end
      it 'for manager' do
        expect(build(:membership, :manager).role? :manager).to eq(true)
      end
    end
  end # #role?

  describe 'self.role_index' do
    Membership::ROLES.each_with_index do |role_name, idx|
      it "correctly returns index for #{role_name}" do
        expect(Membership.role_index(role_name.to_s)).to eq(idx)
      end
    end
  end

  describe 'self.role_name' do
    Membership::ROLES.each_with_index do |role_name, idx|
      it "correctly returns name for index #{idx}" do
        expect(Membership.role_name(idx)).to eq(role_name.to_sym)
      end
    end
  end

  describe '#role_name' do
    it 'returns "Member"' do
      expect(build(:membership).role_name).to eq('Member')
    end
    it 'returns "Worker"' do
      expect(build(:membership, :worker).role_name).to eq('Worker')
    end
    it 'return "Moderator"' do
      expect(build(:membership, :moderator).role_name).to eq('Moderator')
    end
    it 'returns "Manager"' do
      expect(build(:membership, :manager).role_name).to eq('Manager')
    end
  end
end
