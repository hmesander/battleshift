class Activator < ApplicationMailer
  def inform(user)
    @user = user

    mail to: user.email_address, subject: 'Activate Account'
  end
end
