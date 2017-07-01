class AddIndicesToAccountsAndCharges < ActiveRecord::Migration[5.1]
  def change
    add_index :accounts, :account_type
    add_index :accounts, :affiliation

    add_index :charges, :account_id
    add_index :charges, :type
    add_index :charges, :payment_method
    add_index :charges, :semester_code
  end
end
