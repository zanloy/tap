require 'rails_helper'

RSpec.describe "tickets/show", type: :view do

  before(:each) do
    #assign(:ticket, mock_model(Ticket))
    @ability = Object.new.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    @ticket = assign(:ticket, create(:ticket))
    @comments = create_pair(:comment, ticket: @ticket)
    render
  end

  it 'renders the ticket attributes' do
    expect(rendered).to match(/State:/)
    expect(rendered).to match(/Priority:/)
    expect(rendered).to match(/Description:/)
    expect(rendered).to match(/Reported By:/)
  end

  it 'renders the ticket values' do
    expect(rendered).to match(@ticket.human_state_name)
    expect(rendered).to match(@ticket.priority_name)
    expect(rendered).to match(@ticket.description)
    expect(rendered).to match(@ticket.reporter.name)
  end

  it 'renderes comments' do
    @comments.each do |comment|
      expect(rendered).to have_content(comment.comment)
    end
  end
end
