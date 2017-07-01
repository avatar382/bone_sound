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
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  describe "validations" do

    it "must have account_type"

    it "must have email"

    it "must have some kind of name"

    it "must have affiliation if an laser account"

    it "must have affiliation if an internal account"

    it "must not have any affiliation if an external account"

    it "must not have any gatorlink_id if an external account"

    it "if it has an affiliation, it must have a gatorlink id"

    it "gatorlink ids must be unique"

  end

end
