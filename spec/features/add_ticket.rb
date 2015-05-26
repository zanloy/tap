require 'rails_helper'

RSpec.feature 'Add Ticket', type: :feature do
  feature 'add ticket' do
    login
    visit root_path
    page.should have_content('Signed in as')
  end
end
