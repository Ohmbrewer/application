class UserMailer < ActionMailer::Base
  default from: 'noreturn@ohmbrewer.org'

  def follow_up_email(email)
    mail(
        to: email,
        subject: 'Yo yo yo! Sup dawg! Bling bling!'
    ) do |format|
      format.text
    end
  end
end