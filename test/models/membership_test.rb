# == Schema Information
#
# Table name: memberships
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  price       :decimal(8, 2)
#  duration    :integer
#  affiliation :integer
#  is_renewal  :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  test "it should scope on affiliation" do 
  end

  test "it should scope new memberships" do
  end

  test "it should scope renewal memberships" do
  end
end
