# == Schema Information
#
# Table name: charges
#
#  id             :integer          not null, primary key
#  account_id     :integer
#  charge_type    :integer
#  description    :string(255)
#  paid_at        :datetime
#  amount         :decimal(8, 2)
#  payment_method :integer
#  added_by       :integer
#  semester_code  :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deleted_at     :datetime
#  membership_id  :integer
#

Fabricator(:charge) do
  account
  charge_type { Charge::PRINT_CHARGE }
  amount { Faker::Number.decimal(2) }
  payment_method { Charge::UFID_PAYMENT }
end
