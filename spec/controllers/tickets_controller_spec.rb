require 'rails_helper'

RSpec.describe TicketsController, type: :controller do

  context 'as an admin' do
    describe "GET #index" do
      it "assigns all tickets as @tickets" do
        ticket = Ticket.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:tickets)).to eq([ticket])
      end
    end

    describe "GET #show" do
      it "assigns the requested ticket as @ticket" do
        ticket = Ticket.create! valid_attributes
        get :show, {:id => ticket.to_param}, valid_session
        expect(assigns(:ticket)).to eq(ticket)
      end
    end

    describe "GET #new" do
      it "assigns a new ticket as @ticket" do
        get :new, {}, valid_session
        expect(assigns(:ticket)).to be_a_new(Ticket)
      end
    end

    describe "GET #edit" do
      it "assigns the requested ticket as @ticket" do
        ticket = Ticket.create! valid_attributes
        get :edit, {:id => ticket.to_param}, valid_session
        expect(assigns(:ticket)).to eq(ticket)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Ticket" do
          expect {
            post :create, {:ticket => valid_attributes}, valid_session
          }.to change(Ticket, :count).by(1)
        end

        it "assigns a newly created ticket as @ticket" do
          post :create, {:ticket => valid_attributes}, valid_session
          expect(assigns(:ticket)).to be_a(Ticket)
          expect(assigns(:ticket)).to be_persisted
        end

        it "redirects to the created ticket" do
          post :create, {:ticket => valid_attributes}, valid_session
          expect(response).to redirect_to(Ticket.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved ticket as @ticket" do
          post :create, {:ticket => invalid_attributes}, valid_session
          expect(assigns(:ticket)).to be_a_new(Ticket)
        end

        it "re-renders the 'new' template" do
          post :create, {:ticket => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }

        it "updates the requested ticket" do
          ticket = Ticket.create! valid_attributes
          put :update, {:id => ticket.to_param, :ticket => new_attributes}, valid_session
          ticket.reload
          skip("Add assertions for updated state")
        end

        it "assigns the requested ticket as @ticket" do
          ticket = Ticket.create! valid_attributes
          put :update, {:id => ticket.to_param, :ticket => valid_attributes}, valid_session
          expect(assigns(:ticket)).to eq(ticket)
        end

        it "redirects to the ticket" do
          ticket = Ticket.create! valid_attributes
          put :update, {:id => ticket.to_param, :ticket => valid_attributes}, valid_session
          expect(response).to redirect_to(ticket)
        end
      end

      context "with invalid params" do
        it "assigns the ticket as @ticket" do
          ticket = Ticket.create! valid_attributes
          put :update, {:id => ticket.to_param, :ticket => invalid_attributes}, valid_session
          expect(assigns(:ticket)).to eq(ticket)
        end

        it "re-renders the 'edit' template" do
          ticket = Ticket.create! valid_attributes
          put :update, {:id => ticket.to_param, :ticket => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested ticket" do
        ticket = Ticket.create! valid_attributes
        expect {
          delete :destroy, {:id => ticket.to_param}, valid_session
        }.to change(Ticket, :count).by(-1)
      end

      it "redirects to the tickets list" do
        ticket = Ticket.create! valid_attributes
        delete :destroy, {:id => ticket.to_param}, valid_session
        expect(response).to redirect_to(tickets_url)
      end
    end
  end # 'as an admin' context

end
