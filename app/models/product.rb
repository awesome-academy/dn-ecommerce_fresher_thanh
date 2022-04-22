class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy

  validates :name, presence: true
  validates :product_sku, presence: true, uniqueness: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: true
end