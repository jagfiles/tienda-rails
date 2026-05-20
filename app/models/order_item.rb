class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity,   numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than: 0 }

  before_validation :set_unit_price
  before_validation :calculate_subtotal

  private

  def set_unit_price     = self.unit_price ||= product&.price
  def calculate_subtotal = self.subtotal = (unit_price || 0) * (quantity || 0)
end