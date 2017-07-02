class RenameChargeTypeToChargeType < ActiveRecord::Migration[5.1]
  def change
    rename_column :charges, :type, :charge_type
  end
end
