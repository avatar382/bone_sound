class AddCountAndMinimumCountToMaterial < ActiveRecord::Migration[5.1]
  def change
    add_column :materials, :count, :integer
    add_column :materials, :minimum_count, :integer
  end
end
