# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Membership.create(name: "4 month New A^2 Membership",
                  price: 120.00,
                  duration: 120,
                  affiliation: Account::A2_AFFILIATION,
                  is_renewal: false)


Membership.create(name: "4 month Renewal A^2 Membership",
                  price: 120.00,
                  duration: 120,
                  affiliation: Account::A2_AFFILIATION,
                  is_renewal: true)

Membership.create(name: "1 month Renewal A^2 Membership",
                  price: 50.00,
                  duration: 30,
                  affiliation: Account::A2_AFFILIATION,
                  is_renewal: true)

Membership.create(name: "2 month Renewal A^2 Membership",
                  price: 90.00,
                  duration: 60,
                  affiliation: Account::A2_AFFILIATION,
                  is_renewal: true)

Membership.create(name: "4 month New UF Membership",
                  price: 150.00,
                  duration: 120,
                  affiliation: Account::UF_AFFILIATION,
                  is_renewal: false)

Membership.create(name: "4 month Renewal UF Membership",
                  price: 150.00,
                  duration: 120,
                  affiliation: Account::UF_AFFILIATION,
                  is_renewal: true)

Membership.create(name: "1 month Renewal UF Membership",
                  price: 65.00,
                  duration: 30,
                  affiliation: Account::UF_AFFILIATION,
                  is_renewal: true)

Membership.create(name: "2 month Renewal UF Membership",
                  price: 110.00,
                  duration: 60,
                  affiliation: Account::UF_AFFILIATION,
                  is_renewal: true)


