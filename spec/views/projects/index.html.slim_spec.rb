require 'rails_helper'

RSpec.describe 'projects/index', type: :view do
  before(:each) do |variable|
    @ability = Object.new.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability).and_return(@ability)
    @projects = assign(:projects, create_pair(:project))
    render
  end

  it 'renders a list of projects' do
    @projects.each do |project|
      expect(rendered).to match(CGI::escapeHTML(project.name))
    end
  end
end
