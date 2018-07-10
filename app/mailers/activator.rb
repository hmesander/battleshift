class Activator < ApplicationMailer
  def inform(user)
    @user = user
    @confirmation_url = '/activate'

    mail to: user.email_address, subject: 'Activate Account'
  end
end
