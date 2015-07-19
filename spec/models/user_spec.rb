require 'rails_helper'

RSpec.describe User, type: :model do

  it 'creates a valid object' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without an email' do
    expect(build(:user, email: nil)).to be_invalid
  end

  it 'is invalid with a duplicate email' do
    create(:user, email: 'test@test.org')
    expect(build(:user, email: 'test@test.org')).to be_invalid
  end

  it 'is invalid without a name' do
    expect(build(:user, name: nil)).to be_invalid
  end

  it 'is invalid with a duplicate name' do
    create(:user, name: 'John Doe')
    expect(build(:user, name: 'John Doe')).to be_invalid
  end

  describe '#role?' do
    context 'manager role' do
      it 'not for user' do
        expect(build(:user).role? :manager).to eq(false)
      end

      it 'for manager' do
        expect(build(:user, :manager).role? :manager).to eq(true)
      end

      it 'for admin' do
        expect(build(:user, :admin).role? :admin).to eq(true)
      end
    end

    context 'admin role' do
      it 'not for user' do
        expect(build(:user).role? :admin).to eq(false)
      end

      it 'not for manager' do
        expect(build(:user, :manager).role? :admin).to eq(false)
      end

      it 'for admin' do
        expect(build(:user, :admin).role? :admin).to eq(true)
      end
    end
  end

end
