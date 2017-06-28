class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string   :email
      t.string   :first_name
      t.string   :last_name
      t.string   :business_name
      t.string   :phone
      t.string   :gatorlink_id
      t.string   :chartfield
      t.integer  :affiliation
      t.integer  :type
      t.datetime :expires_at

      t.timestamps
    end
  end
end
