# == Schema Information
#
# Table name: charges
#
#  id             :integer          not null, primary key
#  account_id     :integer
#  charge_type    :integer
#  description    :string(255)
#  paid_at        :datetime
#  amount         :decimal(8, 2)
#  payment_method :integer
#  added_by       :integer
#  semester_code  :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deleted_at     :datetime
#  membership_id  :integer
#

require 'test_helper'

class ChargeTest < ActiveSupport::TestCase
  def setup
    @charge = Fabricate(:charge)
    @account = Fabricate(:account)
  end

   ### VALIDATIONS  ###

   test "should not add UFID charge to an account that's external" do
    external_account = Fabricate(:account, account_type: Account::EXTERNAL_CLIENT_TYPE, affiliation: nil, gatorlink_id: nil, ufid: nil)
    internal_account = Fabricate(:account, account_type: Account::INTERNAL_CLIENT_TYPE, affiliation: Account::UF_AFFILIATION)

    invalid = Charge.new(account: external_account, 
                         amount: 45.34, 
                         charge_type: 1, 
                         payment_method: Charge::UFID_PAYMENT)

    assert_not invalid.valid?

    valid = Charge.new(account: internal_account, 
                         amount: 45.34, 
                         charge_type: 1, 
                         payment_method: Charge::CHARTFIELD_PAYMENT)

    assert valid.valid?
   end 

   test "should not add chartfield charge to an account that's external" do
    external_account = Fabricate(:account, account_type: Account::EXTERNAL_CLIENT_TYPE, affiliation: nil, gatorlink_id: nil, ufid: nil)
    internal_account = Fabricate(:account, account_type: Account::INTERNAL_CLIENT_TYPE, affiliation: Account::UF_AFFILIATION)

    invalid = Charge.new(account: external_account, 
                         amount: 45.34, 
                         charge_type: 1, 
                         payment_method: Charge::CHARTFIELD_PAYMENT)

    assert_not invalid.valid?

    valid = Charge.new(account: internal_account, 
                         amount: 45.34, 
                         charge_type: 1, 
                         payment_method: Charge::CHARTFIELD_PAYMENT)

    assert valid.valid?
   end

   test "should not add chartfield charge to an account that doesn't have a chartfield account number" do
    chartfield_account = Fabricate(:account)
    no_chartfield_account = Fabricate(:account, chartfield: nil)

    charge = Fabricate(:charge, account: chartfield_account, payment_method: Charge::CHARTFIELD_PAYMENT);
    assert charge.valid?

    charge.account = no_chartfield_account
    assert_not charge.valid?
   end

   ### CALLBACKS  ###

  # TODO; implement after shibboleth
  # test "should also belong to the account that created test"

  #  > Public Term As String = "2138"  
  #  > 
  #  > The format is  CYYT
  #  > where
  #  > c=2,
  #  > YY=last 2 of year
  #  > T= 8:fall, 1:spring , 5:summer
  test "should set semester code on save" do
    year_arry  = Time.now.year.to_s.split('')
    code_string = "2" + year_arry[2].to_s + year_arry[3].to_s

    assert @charge.semester_code =~ /#{code_string}\d/
  end

  test "should set added by on save" do
    account = Account.first
    assert @charge.added_by == account.id
  end

  test "should fill details out from membership" do
    membership = Membership.create(name: "4 month Renewal A^2 Membership",
                                   price: 120.00,
                                   duration: 120,
                                   affiliation: Account::A2_AFFILIATION,
                                   is_renewal: true)

    charge_via_membership = Charge.new(membership_id: membership.id, 
                                       account: @account,
                                       payment_method: Charge::UFID_PAYMENT)

    assert charge_via_membership.save
    assert charge_via_membership.amount == 120.00
    assert charge_via_membership.description == membership.name
    assert charge_via_membership.charge_type == Charge::MEMBERSHIP_CHARGE
  end

  test "should add time to account starting from today if a membership charge on an expired account" do
    assert @account.expires_at.blank? 

    membership = Membership.create(name: "4 month Renewal A^2 Membership",
                                   price: 120.00,
                                   duration: 120,
                                   affiliation: Account::A2_AFFILIATION,
                                   is_renewal: true)

    charge_via_membership = Charge.new(membership_id: membership.id, 
                                       account: @account,
                                       payment_method: Charge::UFID_PAYMENT)

    assert charge_via_membership.save
    assert @account.expires_at.utc.to_s == (Time.now + 120.days).utc.to_s
  end

  test "should add time to account starting from last active day if a membership charge on an active account" do
    @account.update_attribute(:expires_at, 4.days.from_now)
    old_time = @account.expires_at

    membership = Membership.create(name: "4 month Renewal A^2 Membership",
                                   price: 120.00,
                                   duration: 120,
                                   affiliation: Account::A2_AFFILIATION,
                                   is_renewal: true)

    charge_via_membership = Charge.new(membership_id: membership.id, 
                                       account: @account,
                                       payment_method: Charge::UFID_PAYMENT)

    assert charge_via_membership.save
    assert @account.expires_at.utc.to_s == (old_time + 120.days).utc.to_s
  end

  ### SCOPES ###
  test "should scope on unpaid charges" do
    paid = Fabricate(:charge, paid_at: 3.days.ago)

    assert Charge.unpaid.include?(@charge)
    assert_not Charge.unpaid.include?(paid)
  end

  test "should scope on UFID charges" do
    check = Fabricate(:charge, payment_method: Charge::CHECK_PAYMENT)
    chartfield = Fabricate(:charge, payment_method: Charge::CHARTFIELD_PAYMENT)

    assert Charge.ufid.include?(@charge)
    assert_not Charge.ufid.include?(check)
    assert_not Charge.ufid.include?(chartfield)
  end

  test "should set comped payments to paid immediately" do
    comped = Fabricate(:charge, payment_method: Charge::COMPED_PAYMENT)

    assert comped.paid_at.present?
  end

  ### INSTANCE METHODS ###

  test "should mark itself as paid" do
    @charge.pay!

    assert @charge.paid_at.to_s == Time.now.utc.to_s
  end

end
