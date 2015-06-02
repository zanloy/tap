require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'creates a valid object' do
    expect(build(:comment)).to be_valid
  end

  it 'is invalid without a ticket' do
    expect(build(:comment, ticket: nil)).not_to be_valid
  end

  it 'is invalid without a user' do
    expect(build(:comment, user: nil)).not_to be_valid
  end

  it 'is invalid without a comment' do
    expect(build(:comment, comment: nil)).not_to be_valid
  end
end
