# == Schema Information
#
# Table name: chargefiles
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ChargefileTest < ActiveSupport::TestCase
  test "should mark all charges as paid" do
    skip("implement")
  end

  test "should only be associated with UFID charges" do
    skip("implement")
  end

  test "should create billing file as text" do
    skip("implement")
  end
end
