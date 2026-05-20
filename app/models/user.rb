class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { customer: 0, admin: 1 }
  has_many :orders, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name,  presence: true

  def full_name = "#{first_name} #{last_name}"

  def generate_jwt
    payload = { sub: id, role: role, exp: 1.day.from_now.to_i }
    JWT.encode(payload, Rails.application.secret_key_base, "HS256")
  end
end