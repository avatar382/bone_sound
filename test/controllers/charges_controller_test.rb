require 'test_helper'

class ChargesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @charge = Fabricate(:charge)
  end

  test "should get index" do
    get account_charges_url(@charge.account)
    assert_response :success
  end

  test "should create charge" do
    account = Fabricate(:account)

    assert_difference('Charge.count') do
      post account_charges_url(account), params: { charge: Fabricate.attributes_for(:charge, account: account) }
    end

    assert_redirected_to account_url(account)
  end

  test "should update charge" do
    assert @charge.paid_at.blank?
    put account_charge_url(@charge.account, @charge)

    # charge should be paid
    @charge.reload
    assert_not @charge.paid_at.blank?
    assert_redirected_to account_charges_url(@charge.account)
  end

  test "should destroy charge" do
    account = @charge.account
    assert_difference('Charge.count', -1) do
      delete account_charge_url(account, @charge)
    end

    assert_redirected_to account_charges_url(account)
  end
end
