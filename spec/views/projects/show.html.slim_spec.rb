require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before do
    # setup cancan ability
    @ability = Object.new.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    allow(view).to receive_messages(:page_entries_info => nil)
    allow(view).to receive_messages(:will_paginate => nil)
  end

  before(:each) do
    # setup expected variables
    @project = assign(:project, create(:project))
    @open_tickets = assign(:open_tickets, create_pair(:ticket, project: @project))
    @awaiting_manager = assign(:awaiting_manager, create_pair(:ticket_with_purchases))
    @awaiting_executive = assign(:awaiting_executive, create_pair(:ticket_with_purchases, :manager_approved))
    @closed_tickets = assign(:closed_tickets, [])
    @memberships = assign(:memberships, [])
    render
  end

  it 'shows opened tickets' do
    @open_tickets.each do |ticket|
      expect(rendered).to match(ticket.title)
    end
  end

  it 'shows awaiting_manager tickets' do
    @awaiting_manager.each do |ticket|
      expect(rendered).to match(ticket.title)
    end
  end

  it 'shows awaiting_executive tickets' do
    @awaiting_executive.each do |ticket|
      expect(rendered).to match(ticket.title)
    end
  end

  it 'shows closed tickets' do
    @closed_tickets.each do |ticket|
      expect(rendered).to match(ticket.title)
    end
  end
end
