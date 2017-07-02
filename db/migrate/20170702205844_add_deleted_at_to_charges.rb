class AddDeletedAtToCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :charges, :deleted_at, :datetime
    add_index :charges, :deleted_at
  end
end
