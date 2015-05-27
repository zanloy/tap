require 'rails_helper'

RSpec.feature 'User Tasks', type: :feature do
  feature 'logs in' do
    sign_in

    scenario 'shows the home page' do
      visit root_path
      assert has_content? 'Signed in as'
    end
  end

  feature 'edits tickets' do
    sign_in

    scenario 'creates new ticket' do
      project = FactoryGirl.create(:project)
      visit new_project_ticket_path(project)
      fill_in 'ticket_title', with: 'This is my user ticket.'
      select 'normal', from: 'ticket_priority'
      fill_in 'ticket_description', with: 'Ticket description.'
      click_on 'Create Ticket'
      assert has_content? 'success'
    end

    scenario 'closes own ticket' do
      ticket = FactoryGirl.create(:ticket, reporter: @current_user)
      visit ticket_path(ticket)
      click_on 'Close Ticket'
      assert has_content? 'Ticket closed.'
      assert has_content? 'Closed:'
    end

    scenario 'can not assign ticket' do
      ticket = FactoryGirl.create(:ticket, reporter: @current_user)
      visit edit_ticket_path(ticket)
      assert has_no_select? 'ticket_assignee_id'
    end
  end
end
