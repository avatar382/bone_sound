Fabricator(:membership) do
  name { "New A2 Laser Membership" }
  price { 120 }
  duration { 120 }
  is_renewal { false }
  affiliation { Account::A2_AFFILIATION }
end