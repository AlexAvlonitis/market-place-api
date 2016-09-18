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

end
