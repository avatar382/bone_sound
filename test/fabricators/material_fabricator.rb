# == Schema Information
#
# Table name: materials
#
#  id          :integer          not null, primary key
#  sku         :string(255)
#  price       :decimal(8, 2)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

Fabricator(:material) do
  sku { rand(100000000) }
  description { Faker::Name.last_name }
  price { Faker::Number.decimal(2) }
end
