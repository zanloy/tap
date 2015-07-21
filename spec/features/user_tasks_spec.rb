require 'rails_helper'

RSpec.feature 'User Tasks', type: :feature do
  feature 'logs in' do
    sign_in

    scenario 'shows the home page' do
      visit root_path
      assert has_content? 'Signed in as'
    end
  end

  feature 'basic ticket' do
    let(:ticket) { FactoryGirl.create(:ticket, reporter: @current_user) }
    sign_in

    scenario 'creates new ticket' do
      project = FactoryGirl.create(:project)
      visit new_project_ticket_path(project)
      fill_in 'ticket_title', with: 'This is my user ticket.'
      select 'normal', from: 'ticket_priority'
      fill_in 'ticket_description', with: 'Ticket description.'
      click_on 'Create Ticket'
      assert has_content? 'success'
      assert has_content? 'This is my user ticket.'
      assert has_content? 'Ticket description.'
    end

    #scenario 'creates new ticket with purchases' do
    #  project = FactoryGirl.create(:project)
    #  visit new_project_ticket_path(project)
    #  fill_in 'ticket_title', with: 'This is my user ticket with purchases.'
    #  select 'norma', from: 'ticket_priority'
    #  fill_in 'ticket_description', with: 'Ticket description.'
    #  click_link('add_purchases')
    #  save_and_open_page
    #  find('#purchases .nested-fields').count.should == 1
    #  find(".ticket_purchases_name:last-child input").set('First Item')
    #end

    scenario 'closes own ticket' do
      visit ticket_path(ticket)
      click_on 'Close'
      expect(page).to have_content 'Ticket closed.'
      expect(page).to have_content 'Closed at:'
    end

    scenario 'can not assign ticket' do
      visit ticket_path(ticket)
      assert has_no_select? 'ticket_assignee_id'
    end

    scenario 'does not show moderator or above items' do
      visit ticket_path(ticket)
      assert has_no_button? 'Delete'
    end

    scenario 'can not approve ticket' do
      visit ticket_approve_path(ticket)
      assert has_content? 'You do not have access to do that.'
    end

  end
end
