require 'test_helper'

class MessagesTest < ActionMailer::TestCase
  test "invite_friends" do
    mail = Messages.invite_friends
    assert_equal "Invite friends", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
