require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:georg_ohm)
  end

  test 'layout links' do
    get login_path

    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path

    post login_path, session: { email: @user.email, password: 'password' }
    assert logged_in?
    assert_redirected_to home_path
    follow_redirect!
    assert_template 'home'
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
  end
end
