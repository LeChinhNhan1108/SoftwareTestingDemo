require 'test_helper'
# noinspection ALL

# Test sign up module

class UsersSignupTest < ActionDispatch::IntegrationTest

  test 'invalid sign up information' do
    # Visit users/new
    get signup_path

    # Number of users in DB will not increase
    assert_no_difference 'User.count' do
      # Fill in the sign up form with invalid information
      post users_path, user: {name: '',
                              email: 'user@invalid',
                              password: 'foo',
                              password_confirmation: 'bar'}
    end

    # The page will be
    assert_template 'users/new'

    # Show the errors
    assert_select 'div.alert'

  end

  test 'valid sign up information' do
    # Visit users/new
    get signup_path

    # Number of users in DB will increase by 1
    assert_difference 'User.count', 1 do
      # Fill in the sign up form with valid information
      post_via_redirect users_path, user: {name: 'Example User',
                                           email: 'user@example.com',
                                           password: 'password',
                                           password_confirmation: 'password'}
    end

    # Show the user page
    assert_template 'users/show'

    # The user also be login with
    assert is_logged_in?
  end

end
