require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = Fabricate(:account)
  end

  test "should get index" do
    get accounts_url
    assert_response :success
  end

  test "should search on first_name" do
    search = rand(10000000000)
    waldo = Fabricate(:account, first_name: search)

    get accounts_url(q: "#{search}")

    assert assigns[:accounts].length == 1
    assert assigns[:accounts].include?(waldo)
  end

  test "should search on last_name" do
    search = rand(10000000000)
    waldo = Fabricate(:account, last_name: search)

    get accounts_url(q: "#{search}")
    
    assert assigns[:accounts].length == 1
    assert assigns[:accounts].include?(waldo)
  end

  test "should search on business_name" do
    search = rand(10000000000)
    waldo = Fabricate(:account, business_name: search)

    get accounts_url(q: "#{search}")
    
    assert assigns[:accounts].length == 1
    assert assigns[:accounts].include?(waldo)
  end

  test "should search on email" do
    search = rand(10000000000).to_s + "@gmail.com"
    waldo = Fabricate(:account, email: search)

    get accounts_url(q: "#{search}")
    
    assert assigns[:accounts].length == 1
    assert assigns[:accounts].include?(waldo)
  end

  test "should search on gatorlink_id" do
    search = rand(10000000000)
    waldo = Fabricate(:account, gatorlink_id: search)

    get accounts_url(q: "#{search}")
    
    assert assigns[:accounts].length == 1
    assert assigns[:accounts].include?(waldo)
  end

  test "should get new" do
    get new_account_url
    assert_response :success
  end

  test "should get batch new" do
    get batch_new_accounts_url
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post accounts_url, params: { account: Fabricate.attributes_for(:account) }
    end

    assert_redirected_to account_url(Account.last)
  end

  test "should batch create account, along with a membership charge" do
    m = Fabricate(:membership)

    assert_difference('Account.count') do
      assert_difference('Charge.count') do
        params = {first_name: "New",
                  last_name: "Member",
                  email: "email@thing.com",
                  gatorlink_id: rand(1000000),
                  affiliation: Account::A2_AFFILIATION,
                  account_type: Account::LASER_MEMBER_TYPE}

        post batch_create_accounts_url, params: { account:  params }
      end
    end

    assert = assigns[:account].auto_charge == true
    assert_redirected_to batch_new_accounts_url
  end


  test "should show account" do
    get account_url(@account)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_url(@account)
    assert_response :success
  end

  test "should update account" do
    attrs = Fabricate.attributes_for(:account)
    patch account_url(@account), params: { account: attrs }
    assert_redirected_to account_url(@account)
    @account.reload
    assert @account.first_name == attrs["first_name"]
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete account_url(@account)
    end

    assert_redirected_to accounts_url
  end
end
