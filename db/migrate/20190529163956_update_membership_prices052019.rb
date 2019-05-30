class UpdateMembershipPrices052019 < ActiveRecord::Migration[5.1]
  def change
  	# 1: 4 month new A2
  	Membership.find(1).update(:price => 150.00)

  	# 2: 4 month renew A2
  	Membership.find(2).update(:price => 150.00)

  	# 3: 1 month renew A2
  	Membership.find(3).update(:price => 65.00)

  	# 4: 2 month renew A2
  	Membership.find(4).update(:price => 115.00)

  	# 5: 4 month new UF
  	Membership.find(5).update(:price => 200.00)

  	# 6: 4 month renew UF
  	Membership.find(6).update(:price => 200.00)

  	# 7: 1 month renew UF
  	Membership.find(7).update(:price => 90.00)

  	# 8: 2 month renew UF
  	Membership.find(8).update(:price => 150.00)

  	# 9: new arts scholarship
  	Membership.find(9).update(:price => 75.00)

  	# 10: renew arts scholarship
  	Membership.find(10).update(:price => 75.00)
  end
end
