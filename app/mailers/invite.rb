class Invite < ActionMailer::Base
  default from: "from@example.com"

  def send_invite_email(friend, sender, bar)
    @friend = friend
    @sender = sender
    @bar = bar
    mail(to: @friend, subject: "#{@sender.name} invite you to visit #{@bar.name} or join http://swigbig.com/")
  end
  
  def invite_to_swigbig(friend, bar)
    @friend = friend
    @bar = bar
    mail(to: @friend, subject: "#{@bar.name} have been joined SwigBIG")
  end
  
  def user_invite_to_swigbig(friend, user)
    @friend = friend
    @user = user
    mail(to: @friend, subject: "#{@user.name} have been joined SwigBIG")
  end
end
