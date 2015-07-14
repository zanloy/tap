require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before do
    controller.singleton_class.class_eval do
      protected
      def will_paginate(items)
        nil
      end
      helper_method :will_paginate
    end
  end

  before(:each) do
    # setup cancan ability
    @ability = Object.new.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    # setup expected variables
    @project = assign(:project, create(:project))
    @open_tickets = assign(:open_tickets, create_pair(:ticket, project: @project))
    @closed_tickets = assign(:closed_tickets, [])
    @memberships = assign(:memberships, [])
    render
  end

  it 'shows opened tickets' do
    @open_tickets.each do |ticket|
      expect(rendered).to match(ticket.title)
    end
  end
end
