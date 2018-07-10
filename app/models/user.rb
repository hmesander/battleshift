class User < ApplicationRecord
  has_secure_password
  enum status: [:inactive, :active]

  def send_instructions
    Activator.inform(self).deliver_now
  end
end
