class AddCreditToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :credit, :float
  end
end
