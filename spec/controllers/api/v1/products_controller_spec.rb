require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do

  describe "GET #show" do
    let(:product) { FactoryGirl.create :product }

    before do
      get :show, params: { id: product.id }
    end

    it "returns the information about a reporter on a hash" do
      product_response = json_response
      expect(product_response[:title]).to eq product.title
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do
    before do
      4.times { FactoryGirl.create :product }
      get :index
    end

    it "returns 4 records from the database" do
      products_response = json_response
      expect(products_response.size).to eq 4
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      let(:user) { FactoryGirl.create(:user) }
      let(:product_attributes) { FactoryGirl.attributes_for :product }

      before do
        api_authorization_header user.auth_token
        post :create, { params: { user_id: user.id, product: product_attributes } }
      end

      it "renders the json representation for the product just created" do
        product_response = json_response
        expect(product_response[:title]).to eq product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      let(:user) { FactoryGirl.create :user }
      invalid_product_attributes = { title: "Smart TV", price: "Twelve dollars" }

      before do
        api_authorization_header user.auth_token
        post :create, { params: { user_id: user.id, product: invalid_product_attributes } }
      end

      it "renders an errors json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    let(:user) { FactoryGirl.create :user }
    let(:product) { FactoryGirl.create :product, user: user }

    before do
      api_authorization_header user.auth_token
    end

    context "when is successfully updated" do
      before do
        patch :update, { params: { user_id: user.id, id: product.id,
              product: { title: "An expensive TV" } } }
      end

      it "renders the json representation for the updated user" do
        product_response = json_response
        expect(product_response[:title]).to eq "An expensive TV"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before do
        patch :update, { params: { user_id: user.id, id: product.id,
              product: { price: "two hundred" } } }
      end

      it "renders an errors json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    let(:user) { FactoryGirl.create :user }
    let(:product) { FactoryGirl.create :product, user: user }

    before do
      api_authorization_header user.auth_token
      delete :destroy, { params: {user_id: user.id, id: product.id} }
    end

    it { should respond_with 204 }
  end


end
