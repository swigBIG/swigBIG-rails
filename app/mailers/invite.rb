class Invite < ActionMailer::Base
  default from: "from@example.com"

  def send_invite_email(friend, sender, bar)
    @friend = friend
    @sender = sender
    @bar = bar
    mail(to: @friend, subject: "#{@sender.name} invite you to visit #{@bar.name} or join http://swigbig.com/")
  end
end
