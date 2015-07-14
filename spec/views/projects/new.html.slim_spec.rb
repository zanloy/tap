require 'rails_helper'

RSpec.describe 'projects/new', type: :view do
  it 'renders new project form' do
    ability = Object.new.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(ability)
    assign(:project, Project.new)
    render
    expect(response).to render_template(partial: '_form')
  end
end
