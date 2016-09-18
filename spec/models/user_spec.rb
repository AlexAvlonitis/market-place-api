require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { described_class.new }

  let(:user) { FactoryGirl.create(:user) }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }
  it { should be_valid }

  it { should have_many(:products) }

  context "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_confirmation_of(:password) }
    it { should allow_value('example@domain.com').for(:email) }
    it { should validate_uniqueness_of(:auth_token) }
  end

  describe "#generate_authentication_token!" do

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
      user.generate_authentication_token!
      expect(user.auth_token).not_to eq existing_user.auth_token
    end
  end

  describe "#products association" do

    before do
      user.save
      3.times { FactoryGirl.create :product, user: user }
    end

    it "destroys the associated products on self destruct" do
      products = user.products
      user.destroy
      products.each do |product|
        expect(Product.find(product)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
