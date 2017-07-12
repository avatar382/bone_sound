require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sessions_new_url
    assert_response :success
  end

  test "should login" do
    post login_url

    assert controller.session[:user_id] == 1
    assert_redirected_to accounts_url
  end

  test "should logout" do
    delete logout_url

    assert controller.session[:user_id].nil?
    assert_redirected_to login_url
  end

  test "should redirect if not logged in" do
    get accounts_url
    
    assert_redirected_to login_url
  end
end
