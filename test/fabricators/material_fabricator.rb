Fabricator(:material) do
  sku { rand(100000000) }
  description { Faker::Name.last_name }
  price { Faker::Number.decimal(2) }
end