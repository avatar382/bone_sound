class AddTaxFieldsToCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :charges, :is_taxable, :boolean
    add_column :charges, :tax_charge, :decimal, precision: 8, scale: 2
    add_column :charges, :subtotal, :decimal, precision: 8, scale: 2
  end
end
