class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :restrict_with_error

  validates :name,  presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates :slug,  presence: true, uniqueness: true

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  scope :active,           -> { where(active: true) }
  scope :in_stock,         -> { where("stock > 0") }
  scope :by_category,      ->(cat) { where(category: cat) }
  scope :ordered_by_price, -> { order(:price) }

  def available? = active? && stock > 0
  def to_param   = slug

  private

  def generate_slug
    base = name.downcase.strip.gsub(/\s+/, "-").gsub(/[^a-z0-9\-]/, "")
    self.slug = base
    counter = 1
    while Product.where(slug: slug).where.not(id: id).exists?
      self.slug = "#{base}-#{counter}"
      counter += 1
    end
  end
end