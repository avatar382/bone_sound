# == Schema Information
#
# Table name: charges
#
#  id             :integer          not null, primary key
#  account_id     :integer
#  charge_type    :integer
#  description    :string(255)
#  paid_at        :datetime
#  amount         :decimal(10, )
#  payment_method :integer
#  added_by       :integer
#  semester_code  :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deleted_at     :datetime
#

class Charge < ApplicationRecord
  acts_as_paranoid

  # TYPES
  PRINT_CHARGE      = 1
  CNC_CHARGE        = 2
  WATERJET_CHARGE   = 3
  MATERIALS_CHARGE  = 4
  MEMBERSHIP_CHARGE = 5

  # PAYMENT METHODS
  UFID_PAYMENT       = 1
  CHECK_PAYMENT      = 2
  CHARTFIELD_PAYMENT = 3

  before_create :set_added_by
  before_create :set_semester_code

  belongs_to :account
  # TODO: implement after shibboleth 
  # belongs_to :account, foreign_key: :added_by

  validates :amount, presence: true
  validates :amount, numericality: true
  validates :charge_type, presence: true
  # validates :semester_code, presence: true

  scope :unpaid, -> { where(paid_at: nil) } 
  scope :ufid, -> { where("charge_type = ?", UFID_PAYMENT) } 

  def pay!
  end

  protected

  def set_added_by
    self.added_by = Account.first.id
  end

  #  > Public Term As String = "2138"  
  #  > 
  #  > The format is  CYYT
  #  > where
  #  > c=2,
  #  > YY=last 2 of year
  #  > T= 8:fall, 1:spring , 5:summer 
  def set_semester_code
    month = Time.now.month
    year_arry  = Time.now.year.to_s.split('')

    month_code = case month
    when 1..5
      1
    when 6..7
      5
    when 8..12
      8
    end

    self.semester_code = "2" + year_arry[2].to_s + year_arry[3].to_s + month_code.to_s
  end
  
end
