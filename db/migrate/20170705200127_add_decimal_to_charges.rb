class AddDecimalToCharges < ActiveRecord::Migration[5.1]
  def change
    change_column :charges, :amount, :decimal, precision: 8, scale: 2
  end
end
