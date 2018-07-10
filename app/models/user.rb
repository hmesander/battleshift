class User < ApplicationRecord
  has_secure_password
  validates_presence_of :email_address, :name, :password_digest
  validates_uniqueness_of :email_address
  enum status: [:inactive, :active]

  def send_instructions
    Activator.inform(self).deliver_now
  end
end
