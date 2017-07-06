class CreateMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :materials do |t|
      t.string :sku
      t.decimal :price, precision: 8, scale: 2
      t.string :description

      t.timestamps
    end
  end
end
