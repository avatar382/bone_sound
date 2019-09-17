class FixTaxNotCharged < ActiveRecord::Migration[5.1]
  def change
  	Charge.all.each do |c|
  		if c.is_taxable && (c.amount == c.subtotal)
  			a = c.account
  		  puts "Correcting charge -- name: #{a.first_name + " " + a.last_name} subtotal: #{c.subtotal} tax: #{c.tax_charge} old total: #{c.amount} new total: #{c.amount + c.tax_charge}"
  		  c.update_attribute(:amount, c.subtotal + c.tax_charge)
  		end
  	end
  end
end
