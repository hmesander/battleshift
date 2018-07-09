class User < ApplicationRecord
  has_secure_password
  validates_confirmation_of :password
  enum status: [:inactive, :active]
end
