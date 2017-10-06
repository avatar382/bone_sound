class RenameChargeMaterialIdToMaterialSku < ActiveRecord::Migration[5.1]
  def change
    remove_column :charges, :material_id
    add_column    :charges, :material_sku, :string
  end
end
