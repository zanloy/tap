require 'rails_helper'

RSpec.feature 'User Tasks', type: :feature do

  let(:project) {
    project = FactoryGirl.create(:project)
    project.memberships.create(user: @current_user, role: 2)
    return project
  }

  feature 'logs in' do
    sign_in

    scenario 'shows the home page' do
      visit root_path
      assert has_content? 'Signed in as'
    end
  end

  feature 'moderate tickets' do

    let(:ticket) { FactoryGirl.create(:ticket, project: project) }
    sign_in

    scenario 'closes ticket' do
      visit ticket_path(ticket)
      click_on 'Close'
      assert has_content? 'Ticket closed.'
      assert has_content? 'Closed at:'
    end

    scenario 'can assign ticket' do
      worker = FactoryGirl.create(:user)
      project.memberships.create(user: worker, role: 1)
      visit ticket_path(ticket)
      select worker.name, from: 'ticket_assignee_id'
      select 'urgent', from: 'ticket_priority'
      click_on 'Assign'
      assert has_content? worker.name
    end

    scenario 'deletes ticket' do
      visit ticket_path(ticket)
      click_on 'Delete'
      assert has_content? 'deleted'
    end

    scenario 'can not approve ticket' do
      visit ticket_approve_path(ticket)
      assert has_content? 'You do not have access to do that.'
    end

  end
end
