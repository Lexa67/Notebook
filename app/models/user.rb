class User < ApplicationRecord
  has_many :lessons, dependent: :destroy
  
  validates :name, presence: true
  validates :price, presence: true
  validates :price, numericality: true
end
