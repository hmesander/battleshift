class User < ApplicationRecord
  has_secure_password
  validates_presence_of :email_address, :name, :password_digest, :token
  validates_uniqueness_of :email_address, :token
  enum status: [:inactive, :active]

  def send_instructions
    Activator.inform(self).deliver_now
  end
end
