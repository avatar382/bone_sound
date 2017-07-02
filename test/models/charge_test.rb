# == Schema Information
#
# Table name: charges
#
#  id             :integer          not null, primary key
#  account_id     :integer
#  charge_type    :integer
#  description    :string(255)
#  paid_at        :datetime
#  amount         :decimal(10, )
#  payment_method :integer
#  added_by       :integer
#  semester_code  :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deleted_at     :datetime
#

require 'test_helper'

class ChargeTest < ActiveSupport::TestCase
  def setup
    @charge = Fabricate(:charge)
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

  ### SCOPES ###
  test "should scope on unpaid charges" do
    paid = Fabricate(:charge, paid_at: 3.days.ago)

    assert Charge.unpaid.include?(@charge)
    assert_not Charge.unpaid.include?(paid)
  end

  test "should scope on UFID charges" do
    check = Fabricate(:charge, charge_type: Charge::CHECK_PAYMENT)
    chartfield = Fabricate(:charge, charge_type: Charge::CHARTFIELD_PAYMENT)

    assert Charge.ufid.include?(@charge)
    assert_not Charge.ufid.include?(check)
    assert_not Charge.ufid.include?(chartfield)
  end

end
