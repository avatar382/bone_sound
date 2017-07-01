class CreateCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :charges do |t|
      t.integer :account_id
      t.integer :type
      t.string :description
      t.datetime :paid_at
      t.decimal :amount
      t.integer :payment_method
      t.integer :added_by
      t.string :semester_code

      t.timestamps
    end
  end
end
