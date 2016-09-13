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
end
