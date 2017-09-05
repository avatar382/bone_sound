class AddScholarShipMembershipToMemberships < ActiveRecord::Migration[5.1]
  def change
    Membership.create(name: "New 4 Month Arts Scholarship Membership",
                      price: 60.00,
                      duration: 120,
                      affiliation: Account::A2_AFFILIATION,
                      is_renewal: false)

    Membership.create(name: "Renewal 4 Month Arts Scholarship Membership",
                      price: 60.00,
                      duration: 120,
                      affiliation: Account::A2_AFFILIATION,
                      is_renewal: true)
  end
end
