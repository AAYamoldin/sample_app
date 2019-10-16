class User < ApplicationRecord
  before_save {email.downcase!}
validates :name,length: {maximum: 50},  presence: true
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: {with: VALID_EMAIL_REGEX},uniqueness: true, length: {maximum: 255}, presence: true
has_secure_password
validates :password, length: {minimum: 6}, presence: true
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
