require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test 'welcome email is sent' do
    # Send the email, then test that it got queued
    email = UserMailer.follow_up_email('me@example.com').deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_email_from_equal [UserMailer.default[:from]], email
    assert_email_to_equal ['me@example.com'], email
    assert_email_subject_matches 'Yo yo yo! Sup dawg! Bling bling!', email
    assert_email_body_matches read_fixture('welcome.text.erb').join, email
  end

end