class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum :status, { pending: 0, confirmed: 1, shipped: 2, delivered: 3, cancelled: 4 }

  validates :shipping_address, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  before_save :calculate_total

  def calculate_total
    self.total = order_items.sum(&:subtotal)
  end

  def can_cancel? = pending? || confirmed?
end