require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do

  describe 'User' do
    subject(:ability) { Ability.new(user) }
    let(:user) { build(:user) }
    let(:project) { create(:project) }

    it { is_expected.to be_able_to :read, User: user }
    it { is_expected.to be_able_to :read, Project, private: false }
    it { is_expected.to be_able_to :closed, Project, private: false }
    it { is_expected.to be_able_to :new, Ticket }
    it { is_expected.to be_able_to :create, Ticket }
    it { is_expected.to be_able_to :subscribe, Ticket }
    it { is_expected.to be_able_to :unsubscribe, Ticket }
    it { is_expected.to be_able_to :read, Ticket, reporter: user }

    context 'when is a manager' do
      let(:user) { build(:user, :manager) }
      it { is_expected.to be_able_to :manage, Project }
    end

    context 'when is an admin' do
      let(:user) { build(:user, :admin) }
      it { is_expected.to be_able_to :manage, Project }
    end

    context 'when is an executive' do
      let(:user) { build(:user, :executive) }
      it { is_expected.to be_able_to :approve, Ticket, state_name: :awaiting_manager }
      it { is_expected.to be_able_to :approve, Ticket, state_name: :awaiting_executive }
    end

    shared_examples 'worker' do
      it { is_expected.to be_able_to :read, Ticket, project: project }
      it { is_expected.to be_able_to :close, Ticket, project: project, state_name: :assigned, assignee: user }
      it { is_expected.to be_able_to :self_assign, Ticket, project: project, state: [:unassigned, :assigned] }
      it { is_expected.to be_able_to :reopen, Ticket, project: project, state: :closed, closed_by: user }
    end

    shared_examples 'moderator' do
      it { is_expected.to be_able_to :update, Ticket, project: project, state_name: [:unassigned, :assigned, :awaiting_manager] }
      it { is_expected.to be_able_to :edit, Ticket, project: project, state_name: [:unassigned, :assigned, :awaiting_manager] }
      it { is_expected.to be_able_to :moderate, Ticket, project: project, state_name: [:unassigned, :assigned, :awaiting_manager] }
      it { is_expected.to be_able_to :close, Ticket, project: project, state_name: [:unassigned, :assigned, :awaiting_manager] }
      it { is_expected.to be_able_to :destroy, Ticket, project: project, state_name: [:unassigned, :assigned, :awaiting_manager] }
      it { is_expected.to be_able_to :reopen, Ticket, project: project, state_name: :closed }
    end

    shared_examples 'manager' do
      it { is_expected.to be_able_to :manage, Project, project: project }
      it { is_expected.to be_able_to :approve, Ticket, project: project, state_name: :awaiting_manager }
      it { is_expected.to be_able_to :manager_approve, Ticket, project: project, state_name: :awaiting_manager }
    end

    context 'when is a worker in a project' do
      before(:each) { project.memberships.create(project: project, user: user, role: Membership.role_index(:worker)) }
      it_behaves_like 'worker'
    end

    context 'when is a moderator in a project' do
      before(:each) { project.memberships.create(project: project, user: user, role: Membership.role_index(:moderator)) }
      it_behaves_like 'worker'
      it_behaves_like 'moderator'
    end

    context 'when is a manager in a project' do
      before(:each) { project.memberships.create(project: project, user: user, role: Membership.role_index(:manager)) }
      it_behaves_like 'worker'
      it_behaves_like 'moderator'
      it_behaves_like 'manager'
    end
  end

end
