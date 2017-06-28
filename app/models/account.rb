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
#  type          :integer
#  expires_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Account < ApplicationRecord
  validates :email, presence: true

  UF_AFFILIATION = 1
  A2_AFFILIATION = 2


  def display_name
    if business_name.present?
      business_name
    else
      first_name + " " + last_name
    end

  end
end