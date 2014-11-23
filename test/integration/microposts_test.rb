require 'test_helper'
# noinspection ALL

# Test the micropost module

class MicropostsTest < ActionDispatch::IntegrationTest
  include SessionsHelper
  def setup
    @user = users(:chinhnhan)
  end

  test 'micropost interface' do
    # Login a user
    log_in_as(@user, password: '123456')

    # Visit user/:id
    get user_path(@user)

    # Make sure the page has pagination for feed
    assert_select 'div.pagination'

    # Invalid submission, number of micropost does not increase
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: ''}
    end
    assert_select 'div#error_explanation'

    # Valid submission, number of micropost will increase by 1
    content = 'This micropost really ties the room together'
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_match content, response.body

    # Delete a post.
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit a different user.
    get user_path(users(:archer))
    follow_redirect!
    assert_template 'static_pages/home'
  end
end
