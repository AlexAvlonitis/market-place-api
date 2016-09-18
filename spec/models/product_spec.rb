require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { FactoryGirl.create :product }
  subject { product }

  it { should respond_to(:title) }
  it { should respond_to(:price) }
  it { should respond_to(:published) }
  it { should respond_to(:user_id) }

  it { should belong_to :user }
  
  it "returns published false" do
    expect(subject.published).to eq false
  end

  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of :user_id }
  end

end
