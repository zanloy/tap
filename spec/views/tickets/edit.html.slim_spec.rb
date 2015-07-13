require 'rails_helper'

RSpec.describe 'tickets/edit', type: :view do
  before(:each) do
    @project = assign(:project, create(:project))
    @ticket = assign(:ticket, build(:ticket, project: @project))
    render
  end

  it 'renders the _form partial' do
    expect(response).to render_template(partial: '_form')
  end

  it 'pre-populates the form' do
    assert_select 'input#ticket_title[name=?]', 'ticket[title]', value: @ticket.title
    assert_select 'textarea#ticket_description[name=?]', 'ticket[description]', value: @ticket.description
  end
end
