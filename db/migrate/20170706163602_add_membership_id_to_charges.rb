class AddMembershipIdToCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :charges, :membership_id, :integer
  end
end
