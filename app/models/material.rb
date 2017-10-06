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

class Material < ApplicationRecord
  audited

  validates :sku, presence: true, uniqueness: true
  validates :price, presence: true
  validates :price, numericality: true
  validates :description, presence: true

  scope :filter, ->(q) { where("sku LIKE ? OR description LIKE ? OR price LIKE ?", 
                        "%#{q}%", 
                        "%#{q}%", 
                        "%#{q}%") }

  scope :sku, ->(sku) { where("sku = ?", sku) } 

end
