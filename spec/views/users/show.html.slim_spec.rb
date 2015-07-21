require 'rails_helper'

RSpec.describe "users/show.html.slim", type: :view do
  before(:each) do
    @user = assign(:user, create(:user))
    @current_user = assign(:current_user, @user)
    @assigned_tickets = assign(:tickets, create_pair(:ticket, assignee: @user))
    render
  end

  it 'shows the user name' do
    expect(rendered).to match(@user.name)
  end

  it 'shows the user email' do
    expect(rendered).to match(@user.email)
  end

  it 'shows assigned tickets' do
    @assigned_tickets.each do |ticket|
      expect(rendered).to match(ticket.title)
    end
  end
end
