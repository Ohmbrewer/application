module SharedMailerTests

  def assert_email_subject_matches(matcher, email)
    assert_match matcher, email.subject
  end

  def assert_email_to_equal(matcher, email)
    assert_equal matcher, email.to
  end

  def assert_email_from_equal(matcher, email)
    assert_equal matcher, email.from
  end

  def assert_email_body_matches(matcher, email)
    if email.multipart?
      %w(text html).each do |part|
        assert_match matcher, email.send("#{part}_part").body.to_s
      end
    else
      assert_match matcher, email.body.to_s
    end
  end

end
