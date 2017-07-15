class AddUfidToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :ufid, :string
  end
end
