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

class Membership < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :duration, presence: true
  validates :affiliation, presence: true

  # scopes 
  # If we're looking for memberships for ARTS_AFFILIATION, return ARCH_AFFILIATION memberships.
  # This comes back from the time when ARTS & ARCH constants were the same, and this obviates the need for duplicating memberships which could break stuff for existing memberships.
  scope :affiliation, ->(a) { a == Account::ARTS_AFFILIATION ? 
                                where("affiliation = ?", Account::ARCH_AFFILIATION) : 
                                where("affiliation = ?", a) } 
  scope :new_memberships, -> { where("is_renewal = 0") } 
  scope :renewals, -> { where("is_renewal = 1") } 
end
