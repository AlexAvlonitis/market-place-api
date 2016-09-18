class Product < ApplicationRecord
  validates_presence_of :title, :price, :user_id
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
