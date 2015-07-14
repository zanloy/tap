require 'rails_helper'

RSpec.describe 'projects/edit', type: :view do
  it 'renders an edit project form' do
    ability = Object.new.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(ability)
    assign(:project, build(:project))
    render
    expect(response).to render_template(partial: '_form')
  end
end
