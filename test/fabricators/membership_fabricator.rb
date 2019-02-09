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

Fabricator(:membership) do
  name { "New A2 Laser Membership" }
  price { 120 }
  duration { 120 }
  is_renewal { false }
  affiliation { Account::ARCH_AFFILIATION }
end
