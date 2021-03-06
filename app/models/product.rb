class Product < ApplicationRecord
  include NameSearchable
  include Paginatable

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, :image, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

  enum status: { available: 1, unavailable: 2 }

  belongs_to :productable, polymorphic: true

  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_one_attached :image
end
