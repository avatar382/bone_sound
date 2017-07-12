require 'test_helper'

class BillingControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("admin")
    @charfield_charge = Fabricate(:charge, payment_method: Charge::CHARTFIELD_PAYMENT)
    @check_charge = Fabricate(:charge, payment_method: Charge::CHECK_PAYMENT)
    @ufid_charge_paid = Fabricate(:charge, payment_method: Charge::UFID_PAYMENT, paid_at: 2.days.ago)
    @ufid_charge_unpaid = Fabricate(:charge, payment_method: Charge::UFID_PAYMENT, paid_at: nil)
    
  end

  test "should display only UFID charges" do
    get billing_url

    assert assigns[:charges].include? @ufid_charge_unpaid
    assert_not assigns[:charges].include? @chartfield_charge
    assert_not assigns[:charges].include? @check_charge
  end

  test "should display only unpaid charges" do
    get billing_url

    assert assigns[:charges].include? @ufid_charge_unpaid
    assert_not assigns[:charges].include? @ufid_charge_paid
  end
end
