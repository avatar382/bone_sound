require 'test_helper'

class BillingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unpaid_chartfield_charge = Fabricate(:charge, payment_method: Charge::CHARTFIELD_PAYMENT, paid_at: nil)
    @unpaid_check_charge = Fabricate(:charge, payment_method: Charge::CHECK_PAYMENT, paid_at: nil)
    @ufid_charge_paid = Fabricate(:charge, payment_method: Charge::UFID_PAYMENT, paid_at: 2.days.ago)
    @ufid_charge_unpaid = Fabricate(:charge, payment_method: Charge::UFID_PAYMENT, paid_at: nil)
    
  end

  test "should display only UFID charges" do
    get billing_url(type: 'ufid')

    assert assigns[:charges].include? @ufid_charge_unpaid
    assert_not assigns[:charges].include? @unpaid_chartfield_charge
    assert_not assigns[:charges].include? @unpaid_check_charge
  end

  test "should display only check and chartfield unpaid charges" do
    get billing_url

    assert assigns[:charges].include? @unpaid_check_charge
    assert assigns[:charges].include? @unpaid_chartfield_charge
    assert_not assigns[:charges].include? @ufid_charge_paid
    assert_not assigns[:charges].include? @ufid_charge_unpaid
  end
end
