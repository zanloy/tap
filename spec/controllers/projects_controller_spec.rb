require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  context 'as an admin' do
    login_admin
    set_referer

    let(:project) { create(:project) }

    describe 'GET #index' do
      it 'assigns all projects as @projects' do
        get :index, {}, @session
        expect(assigns(:projects)).to eq([project])
      end
    end

    describe 'GET #show' do
      it 'assigns the requested project as @project' do
        get :show, {id: project.to_param}, @session
        expect(assigns(:project)).to eq(project)
      end
    end

    describe 'GET #new' do
      it 'assigns a new project as @project' do
        get :new, {}, @session
        expect(assigns(:project)).to be_a_new(Project)
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested project as @project' do
        get :edit, {id: project.to_param}, @session
        expect(assigns(:project)).to eq(project)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Project' do
          expect {
            post :create, {project: attributes_for(:project)}, @session
          }.to change(Project, :count).by(1)
        end

        it 'assigns a newly created project as @project' do
          post :create, {project: attributes_for(:project)}, @session
          expect(assigns(:project)).to be_a(Project)
          expect(assigns(:project)).to be_persisted
        end

        it 'redirects to the created project' do
          post :create, {project: attributes_for(:project)}, @session
          expect(response).to redirect_to(Project.last)
        end
      end

      context 'with invalid params' do
        it 'assigns a newly created but unsaved project as @project' do
          post :create, {project: attributes_for(:project, :invalid)}, @session
          expect(assigns(:project)).to be_a_new(Project)
        end

        it "re-renders the 'new' template" do
          post :create, {project: attributes_for(:project, :invalid)}, @session
          expect(response).to render_template("new")
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do

        let(:new_attributes) { { name: 'New Project Name' } }

        it 'updates the requested project' do
          put :update, { id: project.to_param, project: new_attributes}, @session
          project.reload
          expect(project.name).to eq('New Project Name')
        end

        it 'assigns the requested project as @project' do
          put :update, { id: project.to_param, project: new_attributes}, @session
          expect(assigns(:project)).to eq(project)
        end

        it 'redirects to the project' do
          put :update, { id: project.to_param, project: new_attributes}, @session
          expect(response).to redirect_to(project)
        end
      end

      context 'with invalid params' do

        it 'assigns the project as @project' do
          put :update, { id: project.to_param, project: attributes_for(:project, :invalid)}, @session
          expect(assigns(:project)).to eq(project)
        end

        it "re-renders the 'edit' template" do
          put :update, { id: project.to_param, project: attributes_for(:project, :invalid)}, @session
          expect(response).to render_template("edit")
        end
      end
    end

    describe 'DELETE #destroy' do

      before(:each) { @project = create(:project) }

      it 'destroys the requested project' do
        expect {
          delete :destroy, { id: @project.to_param}, @session
        }.to change(Project, :count).by(-1)
      end

      it 'redirects to the projects list' do
        delete :destroy, { id: @project.to_param}, @session
        expect(response).to redirect_to(projects_url)
      end
    end
  end # context 'as an admin'

end
