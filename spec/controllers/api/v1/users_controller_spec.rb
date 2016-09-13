require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before { request.headers['Accept'] = "application/marketplace.v1" }

  describe "GET #show" do
    let(:user) { FactoryGirl.create :user }
    before { get :show, params: { id: user.id }, format: :json }

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eq user.email
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context 'When is successfuly created' do
      let(:user_attributes) { FactoryGirl.attributes_for :user }

      before do
        post :create, { user: user_attributes }, format: :json
      end

      it "renders the json representation for user just created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'When is not created' do
      pass = 'asdasdasd'
      invalid_user_attrs = { password: pass, password_confirmation: pass}

      before do
        post :create, { user: invalid_user_attrs }, format: :json
      end

      it "renders an error json" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end

  end
end
