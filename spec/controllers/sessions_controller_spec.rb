require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    it 'adds the user.id to session'
    it 'redirects to root_url'
  end

  describe 'DELETE #destroy' do
    it 'resets the session'
    it 'redirects to root_url'
  end
end
