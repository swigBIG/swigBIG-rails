class Invite < ActionMailer::Base
  default from: "from@example.com"

  def send_invite_email(friend, sender)
    @friend = friend
    @sender = sender
    mail(:to => @friend, :subject => "Swigbig Invitation")
  end
end
