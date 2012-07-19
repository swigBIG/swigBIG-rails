class Messages < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.messages.invite_friends.subject
  #
  def invite_friends
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
