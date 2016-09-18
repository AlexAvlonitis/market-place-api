require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe "POST #ceate" do
    let(:user) { FactoryGirl.create(:user) }

    context "when the credential are correct" do
      before do
        credentials = { email: user.email, password: user.password }
        post :create, { params: { session: credentials } }
      end

      it "returns the user record corresponding to the given credentials" do
        user.reload
        expect(json_response[:auth_token]).to eq user.auth_token
      end

      it { should respond_with 200 }
    end

    context "when credentials are incorrect" do
      before do
        credentials = { email: user.email, password: 'invalidPassword' }
        post :create, { params: { session: credentials } }
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eql "Invalid email or password"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      delete :destroy, params: { id: user.auth_token }
    end

    it { should respond_with 204 }
  end
end
