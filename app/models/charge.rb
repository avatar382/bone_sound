# == Schema Information
#
# Table name: charges
#
#  id             :integer          not null, primary key
#  account_id     :integer
#  type           :integer
#  description    :string(255)
#  paid_at        :datetime
#  amount         :decimal(10, )
#  payment_method :integer
#  added_by       :integer
#  semester_code  :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Charge < ApplicationRecord
end
