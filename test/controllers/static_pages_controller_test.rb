require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  test 'should get help' do
    get :help
    assert_response :success
    assert_select 'title', 'Help | Ohmbrewer'
  end

  test 'should get contact' do
    get :contact
    assert_response :success
    assert_select 'title', 'Contact | Ohmbrewer'
  end

  test 'should get about' do
    get :about
    assert_response :success
    assert_select 'title', 'About | Ohmbrewer'
  end

end