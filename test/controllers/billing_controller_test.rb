require 'test_helper'

class BillingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @paid_chartfield_charge = Fabricate(:charge, payment_method: Charge::CHARTFIELD_PAYMENT, paid_at: 3.days.ago)
    @unpaid_chartfield_charge = Fabricate(:charge, payment_method: Charge::CHARTFIELD_PAYMENT, paid_at: nil)

    @paid_check_charge = Fabricate(:charge, payment_method: Charge::CHECK_PAYMENT, paid_at: 3.days.ago)
    @unpaid_check_charge = Fabricate(:charge, payment_method: Charge::CHECK_PAYMENT, paid_at: nil)

    @ufid_charge_paid = Fabricate(:charge, payment_method: Charge::UFID_PAYMENT, paid_at: 2.days.ago)
    @ufid_charge_unpaid = Fabricate(:charge, payment_method: Charge::UFID_PAYMENT, paid_at: nil)
    
    @comped_charge = Fabricate(:charge, payment_method: Charge::COMPED_PAYMENT)
  end

  test "should display only unpaid UFID charges" do
    get billing_url(type: 'ufid')

    assert assigns[:charges].include? @ufid_charge_unpaid

    assert_not assigns[:charges].include? @ufid_charge_paid

    assert_not assigns[:charges].include? @paid_chartfield_charge
    assert_not assigns[:charges].include? @unpaid_chartfield_charge

    assert_not assigns[:charges].include? @paid_check_charge
    assert_not assigns[:charges].include? @unpaid_check_charge

    assert_not assigns[:charges].include? @comped_charge
  end

  test "should display only unpaid check charges" do
    get billing_url(type: 'check')

    assert assigns[:charges].include? @unpaid_check_charge

    assert_not assigns[:charges].include? @ufid_charge_paid
    assert_not assigns[:charges].include? @ufid_charge_unpaid

    assert_not assigns[:charges].include? @paid_chartfield_charge
    assert_not assigns[:charges].include? @unpaid_chartfield_charge

    assert_not assigns[:charges].include? @paid_check_charge

    assert_not assigns[:charges].include? @comped_charge
  end

  test "should display only chartfield charges" do
    get billing_url(type: 'chartfield')

    assert assigns[:charges].include? @unpaid_chartfield_charge

    assert_not assigns[:charges].include? @ufid_charge_paid
    assert_not assigns[:charges].include? @ufid_charge_unpaid

    assert_not assigns[:charges].include? @paid_chartfield_charge

    assert_not assigns[:charges].include? @paid_check_charge
    assert_not assigns[:charges].include? @unpaid_check_charge

    assert_not assigns[:charges].include? @comped_charge
  end

  test "should display only comped charges" do
    get billing_url(type: 'comped')

    assert assigns[:charges].include? @comped_charge

    assert_not assigns[:charges].include? @ufid_charge_paid
    assert_not assigns[:charges].include? @ufid_charge_unpaid

    assert_not assigns[:charges].include? @paid_chartfield_charge
    assert_not assigns[:charges].include? @unpaid_chartfield_charge

    assert_not assigns[:charges].include? @paid_check_charge
    assert_not assigns[:charges].include? @unpaid_check_charge

  end
end
