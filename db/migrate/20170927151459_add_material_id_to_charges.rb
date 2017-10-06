class AddMaterialIdToCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :charges, :material_id, :integer
  end
end
