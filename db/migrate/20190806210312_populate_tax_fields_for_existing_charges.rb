class PopulateTaxFieldsForExistingCharges < ActiveRecord::Migration[5.1]
  def change
  	Charge.with_deleted.each do |c|
  		c.is_taxable = false
  		c.tax_charge = 0.0
  		c.subtotal   = c.amount
  		c.save(:validate => false)
  	end
  end
end
