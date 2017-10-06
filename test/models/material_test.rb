# == Schema Information
#
# Table name: materials
#
#  id            :integer          not null, primary key
#  sku           :string(255)
#  price         :decimal(8, 2)
#  description   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  count         :integer
#  minimum_count :integer
#

require 'test_helper'

class MaterialTest < ActiveSupport::TestCase
  def setup
    @material = Fabricate(:material)
  end

  test "should be valid" do 
    assert @material.valid?
  end
end
