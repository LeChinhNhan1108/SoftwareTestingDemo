require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:chinhnhan)
  end

  test "index including pagination" do
    log_in_as(@user, password: '123456')
    get users_path
    assert_template 'users/index'
    assert_select 'div', {count: 2, class: 'pagination'}

    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end
