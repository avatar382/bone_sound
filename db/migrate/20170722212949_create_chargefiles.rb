class CreateChargefiles < ActiveRecord::Migration[5.1]
  def change
    create_table :chargefiles do |t|
      t.timestamps
    end

    add_column :charges, :chargefile_id, :integer
    add_column :charges, :refunded_at, :datetime
    add_index :charges, :chargefile_id
  end
end
