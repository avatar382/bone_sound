require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = Fabricate(:account)

    @external_account = Fabricate(:account, account_type: Account::EXTERNAL_CLIENT_TYPE, ufid: nil, chartfield: nil, affiliation: nil, gatorlink_id: nil)

    @active_laser_account = Fabricate(:account, account_type: Account::LASER_MEMBER_TYPE, expires_at: 3.days.from_now)

    @never_charged_laser_account = Fabricate(:account, account_type: Account::LASER_MEMBER_TYPE, expires_at: nil)

    @expired_laser_account = Fabricate(:account, account_type: Account::LASER_MEMBER_TYPE, expires_at: 3.days.ago)

    @old_laser_account = Fabricate(:account, account_type: Account::LASER_MEMBER_TYPE, expires_at: 3.days.from_now, created_at: 1.month.ago)

    @new_laser_account = Fabricate(:account, account_type: Account::LASER_MEMBER_TYPE, expires_at: 3.days.from_now, created_at: 1.day.ago)
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

  test "should search on ufid" do
    search = rand(899999)+10000000 
    waldo = Fabricate(:account, ufid: search)

    get accounts_url(q: "#{search}")
    
    assert assigns[:accounts].length == 1
    assert assigns[:accounts].include?(waldo)
  end

  test "returns all accounts" do
    get accounts_url(filter: "all")

    assert assigns[:accounts].length == 7
  end

  test "returns uncharged laser accounts" do
    get accounts_url(filter: "uncharged_laser")

    assert assigns[:accounts].length == 2
    assert assigns[:accounts].include? @account
    assert assigns[:accounts].include? @never_charged_laser_account
  end

  test "returns active laser accounts" do
    get accounts_url(filter: "active_laser")

    assert assigns[:accounts].length == 3
    assert assigns[:accounts].include? @active_laser_account
    assert assigns[:accounts].include? @old_laser_account
    assert assigns[:accounts].include? @new_laser_account
  end

  test "returns expired laser accounts" do
    get accounts_url(filter: "expired_laser")

    assert assigns[:accounts].length == 1
    assert assigns[:accounts].include? @expired_laser_account
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

    skip
    assert_redirected_to account_url(assigns(:account))
  end

  test "should batch create account, along with a membership charge" do
    m = Fabricate(:membership)

    assert_difference('Account.count') do
      assert_difference('Charge.count') do
        params = {first_name: "New",
                  last_name: "Member",
                  email: "email@thing.com",
                  gatorlink_id: rand(1000000),
                  ufid: rand(89999999)+10000000,
                  affiliation: Account::ARCH_AFFILIATION,
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

    assert_redirected_to accounts_url(filter: "all")
  end
end
