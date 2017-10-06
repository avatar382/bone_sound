class AddMaterialCountToCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :charges, :material_count, :integer
  end
end
