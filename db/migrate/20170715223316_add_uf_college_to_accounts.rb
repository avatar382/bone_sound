class AddUfCollegeToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :uf_college, :string
  end
end
