require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  context 'as an admin' do
    login_admin
    set_referer

    let(:ticket) { create(:ticket) }

    describe 'POST #create' do
      it 'creates a new comment' do
        expect {
          post :create, {ticket_id: ticket.to_param, comment: attributes_for(:comment)}, @session
        }.to change {Comment.count}.by(1)
      end

      it 'redirects to :back' do
        post :create, {ticket_id: ticket.to_param, comment: attributes_for(:comment)}, @session
        expect(response).to redirect_to(:back)
      end
    end

    describe 'DELETE #destroy' do

      before(:each) { @comment = create(:comment, ticket: ticket) }

      it 'destroys the comment' do
        expect {
          delete :destroy, { id: @comment.to_param }, @session
        }.to change {Comment.count}.by(-1)
      end

      it 'redirects to the ticket' do
        delete :destroy, { id: @comment.to_param }, @session
        expect(response).to redirect_to(:back)
      end
    end
  end # 'as an admin' context
end
