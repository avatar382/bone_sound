# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  email         :string(255)
#  first_name    :string(255)
#  last_name     :string(255)
#  business_name :string(255)
#  phone         :string(255)
#  gatorlink_id  :string(255)
#  chartfield    :string(255)
#  affiliation   :integer
#  account_type  :integer
#  expires_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#  ufid          :string(255)
#  uf_college    :string(255)
#  credit        :float(24)
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @account = Fabricate(:account)
  end

  ### VALIDATIONS ###
  test "must have some kind of name" do
    @account.first_name = nil
    @account.last_name = nil
    @account.business_name = nil

    # no names set == NOT VALID
    assert_not @account.valid?

    # only business set == VALID
    @account.business_name = "Foo"
    assert @account.valid?

    # only first set == NOT VALID
    @account.business_name = nil
    @account.first_name = "Foo"
    assert_not @account.valid?

    # only last set == NOT VALID
    @account.first_name = nil
    @account.last_name = "Bar"
    assert_not @account.valid?

    # only first and last set == VALID
    @account.first_name = "Foo"
    @account.last_name = "Bar"
    assert @account.valid?
  end

  test "must have affiliation if an laser account" do
    laser_account = Fabricate(:account, 
                              account_type: Account::LASER_MEMBER_TYPE,
                              affiliation: Account::UF_AFFILIATION)

    assert laser_account.valid?

    laser_account.affiliation = nil
    assert_not laser_account.valid?
  end

  test "must have affiliation if an internal account" do
    internal_account = Fabricate(:account, 
                                 account_type: Account::INTERNAL_CLIENT_TYPE,
                                 affiliation: Account::UF_AFFILIATION)

    assert internal_account.valid?

    internal_account.affiliation = nil
    assert_not internal_account.valid?
  end

  test "must not have any affiliation if an external account" do
    external_account = Fabricate(:account, 
                                 account_type: Account::EXTERNAL_CLIENT_TYPE,
                                 affiliation: nil,
                                 ufid: nil,
                                 gatorlink_id: nil)

    assert external_account.valid?

    external_account.affiliation = Account::UF_AFFILIATION
    assert_not external_account.valid?
  end

  test "must not have any gatorlink_id if an external account" do
    external_account = Fabricate(:account, 
                                 account_type: Account::EXTERNAL_CLIENT_TYPE,
                                 affiliation: nil,
                                 ufid: nil,
                                 gatorlink_id: nil)

    assert external_account.valid?

    external_account.gatorlink_id = rand(100000)
    assert_not external_account.valid?
  end

  test "if it has an affiliation, it must have a gatorlink id" do
    internal_account = Fabricate(:account, 
                                 account_type: Account::INTERNAL_CLIENT_TYPE,
                                 affiliation: Account::UF_AFFILIATION)

    assert internal_account.valid?

    internal_account.gatorlink_id = nil
    assert_not internal_account.valid?
  end

  test "must not have any ufid if an external account" do
    external_account = Fabricate(:account, 
                                 account_type: Account::EXTERNAL_CLIENT_TYPE,
                                 affiliation: nil,
                                 gatorlink_id: nil,
                                 ufid: nil)

    assert external_account.valid?

    external_account.ufid = rand(89999999)+10000000
    assert_not external_account.valid?
  end

  test "ufid must be 8 digits"  do
    internal_account = Fabricate(:account, 
                                 account_type: Account::INTERNAL_CLIENT_TYPE,
                                 affiliation: Account::UF_AFFILIATION)

    assert internal_account.valid?

    internal_account.ufid = "1234567"
    assert_not internal_account.valid?

    internal_account.ufid = "123456789"
    assert_not internal_account.valid?

    internal_account.ufid = "ab1234567"
    assert_not internal_account.valid?

    internal_account.ufid = "12345678a"
    assert_not internal_account.valid?

    internal_account.ufid = "1245678a"
    assert_not internal_account.valid?
  end


  ### CALLBACKS ###

  test "should automatically add a laser membership charge if auto_charge is set" do
    m = Fabricate(:membership)

    params = {first_name: "New",
              last_name: "Member",
              email: "email@thing.com",
              gatorlink_id: rand(1000000),
              ufid: rand(89999999)+10000000,
              affiliation: Account::A2_AFFILIATION,
              account_type: Account::LASER_MEMBER_TYPE}

    account = Account.new(params)
    account.auto_charge = true

    assert_difference('Charge.count') do
      account.save
    end

    charge = account.charges.first

    assert charge.amount == m.price
    assert charge.description == m.name
    assert charge.payment_method == Charge::UFID_PAYMENT
    assert charge.membership_id == m.id
    assert charge.charge_type == Charge::MEMBERSHIP_CHARGE
  end
end
