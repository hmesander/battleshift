class User < ApplicationRecord
  has_secure_password
  validates_presence_of :email_address, :name, :password_digest, :token
  validates_uniqueness_of :email_address, :token
  enum status: [:inactive, :active]

  def create_token
    self[:token] = SecureRandom.urlsafe_base64
  end
end
