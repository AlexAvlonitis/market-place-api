require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { described_class.new }

  let(:user) { FactoryGirl.create(:user) }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should be_valid }
end
