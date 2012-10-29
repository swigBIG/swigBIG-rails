class RewardsMessages < ActionMailer::Base
  default from: "swigbig@noreply.ca"

  def popularity_reward_email(user, bar, coupon)
    @user = user
    @bar = bar
    @coupon = coupon
    mail(to: @user.email, subject: "#{@user.name rescue @user.email} has won #{@bar.popularity.reward_detail} from #{@bar.name}!")
  end
end
