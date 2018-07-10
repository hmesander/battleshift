class Activator < ApplicationMailer
  def inform(user, url)
    @user = user
    @url = url
    mail to: user.email_address, subject: 'Activate Account'
  end
end
