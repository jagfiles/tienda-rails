class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  def to_param = slug

  private

  def generate_slug
    self.slug = name.downcase.strip.gsub(/\s+/, "-").gsub(/[^a-z0-9\-]/, "")
  end
end