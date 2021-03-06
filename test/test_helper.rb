require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'simplecov'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'shared/shared_mailer_tests'
module ActionMailer
  class TestCase
    include SharedMailerTests
  end
end

module ActiveSupport
  class TestCase
    include ActiveJob::TestHelper # Needed to support ActiveJob testing

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Returns true if a test user is logged in.
    def logged_in?
      !session[:user_id].nil?
    end

    # Logs in a test user.
    def log_in_as(user, options = {})
      password    = options[:password]    || 'password'
      remember_me = options[:remember_me] || '1'
      if integration_test?
        post login_path, session: { email:       user.email,
                                    password:    password,
                                    remember_me: remember_me }
      else
        session[:user_id] = user.id
      end
    end

    # Add more helper methods to be used by all tests here...

    private

      # Returns true inside an integration test.
      def integration_test?
        defined?(post_via_redirect)
      end
  end
end

require 'knapsack'

knapsack_adapter = Knapsack::Adapters::MinitestAdapter.bind
knapsack_adapter.set_test_helper_path(__FILE__)
