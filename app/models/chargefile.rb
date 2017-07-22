# == Schema Information
#
# Table name: chargefiles
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Chargefile < ApplicationRecord
  has_many :charges

  after_create :mark_charges_as_paid
  validate     :charges_are_ufid_charges

  # generates string representing a billing file
  def generate_text_content
    content_string = ""

    sum             = 0
    count           = 0
    full_date       = Time.now.strftime("%m%d%Y")
    full_date_ymd   = Time.now.strftime("%Y%m%d")
    month_date      = Time.now.strftime("%m%d")
    dashed_date     = Time.now.strftime("%m-%d-%Y")
    dashed_time     = (Time.now).strftime("%H:%M:%S")

    self.charges.each do |charge|
      amount_string = sprintf("%07.2f", charge.amount.to_f)
      type_string   = charge.charge_type == Charge::MEMBERSHIP_CHARGE ? "321000000001" : "321000000004"
      id_string     = month_date + "1" + sprintf("%03.0f", count) 

      # create the billing line
      # SAMPLE: OTH 32100000000488239101               034.00AAFABLAB00002320              215812042015
      content_string += "OTH #{type_string}#{charge.account.ufid}              #{amount_string}AAFABLAB#{id_string}              #{charge.semester_code}#{full_date}\n"

      # increment my things
      count += 1
      sum   += charge.amount.to_f
    end

    # last line time
    # SAMPLE: C0024012-04-201508:28:56 015      00627.69 
    content_string += "C00240#{dashed_date}#{dashed_time} #{sprintf("%03.0f",count)}      #{sprintf("%08.2f", sum)}\n"

    return content_string
  end

  protected

  def mark_charges_as_paid
    self.charges.each do |charge|
      charge.pay!
    end
  end


  def charges_are_ufid_charges
    self.charges.each do |charge|
      errors.add(:base, "All charges must be UFID") unless charge.payment_method == Charge::UFID_PAYMENT
    end
  end
end
