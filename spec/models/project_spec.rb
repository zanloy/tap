require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'creates a valid object' do
    expect(build(:project)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build(:project, name: nil)).to be_invalid
  end

  it 'requires a unique name' do
    create(:project, name: 'Project')
    expect(build(:project, name: 'Project')).to be_invalid
  end

  describe '#user_role?' do
    it "returns the user's role" do
      user = create(:user)
      project = create(:project)
      create(:membership, :moderator, project: project, user: user)
      expect(project.user_role? user).to eq(2)
    end
  end

  describe '#workers' do
    it 'returns a list of workers' do
      project = create(:project)
      create(:membership, project: project) # To make sure it's not included
      workers = create_list(:membership, 5, :worker, project: project)
      expect(project.workers).to match_array(workers)
    end
  end
end
