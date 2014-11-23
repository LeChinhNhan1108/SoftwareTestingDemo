require 'test_helper'
# noinspection ALL

# Test the login module

class UsersLoginTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  def setup
    @user = users(:chinhnhan)
  end

  test 'login with valid information' do

    # Visit login page
    get login_path

    # Fill in the login form with valid information
    post login_path, session: { email: @user.email, password: '123456' }

    # Make sure user is directed to the show page
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_template 'users/show'

    # Show the logout path, not the login path
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
  end


  test 'login with invalid information' do
    # Visit login page
    get login_path

    # Fill in the login form with invalid information
    post login_path, session: { email: @user.email, password: '1234567890' }

    # Render the form again with errors
    assert_template 'sessions/new'
    assert_select 'div.alert'
  end


  test 'login with valid information followed by logout' do

    # Visit login page
    get login_path

    # Fill in the login form with valid information
    post login_path, session: { email: @user.email, password: '123456' }

    # Make sure user is logged in
    assert is_logged_in?

    # When user is logged in, redirect him/her to the user/:id
    assert_redirected_to user_path(@user)
    follow_redirect!

    # Template to render the page
    assert_template 'users/show'

    # Show the logout path, not the login path
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path

    # Log out user
    delete logout_path

    # Make sure that user is logged out
    assert_not is_logged_in?

    # User is redirected to home page
    assert_redirected_to root_url
    follow_redirect!

    # Show the login path, not the logout path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path,      count: 0
  end

end
