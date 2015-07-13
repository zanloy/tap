require 'rails_helper'

RSpec.describe "tickets/new", type: :view do
  it 'renders the _form partial' do
    assign(:project, create(:project))
    assign(:ticket, Ticket.new)
    render
    expect(response).to render_template(partial: '_form')
  end
end
