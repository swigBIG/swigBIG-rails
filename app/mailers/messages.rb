class Messages < ActionMailer::Base
  default from: "swigbig@noreply.ca"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.messages.invite_friends.subject

  def invite_friends
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def new_email_account_password(user, new_password)
    @new_password = new_password
    @user = user
    mail(to: @user.email, subject: "New Password Account")
  end

end
