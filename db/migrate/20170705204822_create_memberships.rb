class CreateMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :memberships do |t|
      t.string :name
      t.decimal :price, precision: 8, scale: 2
      t.integer :duration
      t.integer :affiliation 
      t.boolean :is_renewal

      t.timestamps
    end
  end
end
