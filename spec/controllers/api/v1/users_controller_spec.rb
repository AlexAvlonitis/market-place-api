require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe "GET #show" do
    let(:user) { FactoryGirl.create :user }
    before { get :show, params: { id: user.id }, format: :json }

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eq user.email
    end

    it "has the product ids as an embedded object" do
      user_response = json_response
      expect(user_response[:products]).to eq []
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context 'When is successfuly created' do
      let(:user_attributes) { FactoryGirl.attributes_for :user }

      before do
        post :create, { params: {user: user_attributes} }, format: :json
      end

      it "renders the json representation for user just created" do
        user_response = json_response
        expect(user_response[:email]).to eq user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'When is not created' do
      pass = 'asdasdasd'
      invalid_user_attrs = { password: pass, password_confirmation: pass}

      before do
        post :create, { params: {user: invalid_user_attrs} }, format: :json
      end

      it "renders an error json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    context 'When is successfuly updated' do
      let(:user) { FactoryGirl.create(:user) }
      user_email = { email: "fd@asd.com" }

      before do
        api_authorization_header user.auth_token
        put :update, { params: {id: user.id, user: user_email} }, format: :json
      end

      it "renders the json representation for user updated" do
        user_response = json_response
        expect(user_response[:email]).to eq user_email[:email]
      end

      it { should respond_with 201 }
    end

    context 'When is not created' do
      let(:user) { FactoryGirl.create(:user) }
      user_email = { email: "bademail.com" }

      before do
        api_authorization_header user.auth_token
        put :update, { params: {id: user.id, user: user_email} }, format: :json
      end

      it "renders errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      api_authorization_header user.auth_token
      delete :destroy, { params: {id: user.id} }, format: :json
    end

    it { should respond_with 204 }
  end
end
