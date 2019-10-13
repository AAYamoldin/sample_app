class User < ApplicationRecord
  before_save {email.downcase!}
validates :name,:email, presence: true
validates :name, length: {maximum: 50}, presence: true
validates :email, length: {maximum: 255}, presence: true
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: {with: VALID_EMAIL_REGEX}, presence: true
validates :email, uniqueness: true, :presence => true
has_secure_password
validates :password, length: {minimum: 6}, presence: true
end
