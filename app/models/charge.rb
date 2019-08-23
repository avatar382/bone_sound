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
#  chargefile_id  :integer
#  refunded_at    :datetime
#  material_sku   :string(255)
#  material_count :integer
#

class Charge < ApplicationRecord
  acts_as_paranoid
  audited

  # TYPES
  PRINT_CHARGE      = 1
  CNC_CHARGE        = 2
  WATERJET_CHARGE   = 3
  MATERIALS_CHARGE  = 4
  MEMBERSHIP_CHARGE = 5
  LASER_CHARGE      = 6
  DESIGN_CHARGE     = 7

  # PAYMENT METHODS
  UFID_PAYMENT       = 1
  CHECK_PAYMENT      = 2
  CHARTFIELD_PAYMENT = 3
  COMPED_PAYMENT     = 4

  # TAX RATE
  TAX_RATE = 0.07

  before_create :set_added_by
  before_create :set_semester_code
  before_create :set_comped_charges_to_paid
  before_validation :fill_details_via_membership_id
  after_create  :add_time_to_account_if_membership_charge
  after_create  :deduct_from_credit
  after_create  :deduct_inventory_counts
  before_save   :calculate_tax

  belongs_to :account
  belongs_to :chargefile, optional: true
  belongs_to :membership, optional: true
  # TODO: implement after shibboleth 
  # belongs_to :account, foreign_key: :added_by

  validates :amount, presence: true
  validates :subtotal, numericality: true, allow_blank: true
  validates :tax_charge, numericality: true, allow_blank: true
  validates :amount, numericality: true
  validates :charge_type, presence: true
  validates :payment_method, presence: true
  validate  :charges_on_external_accounts_must_be_check
  validate  :chartfield_payments_require_chartfield_on_account
  validate  :ufid_payments_require_ufid_on_account
  validate  :materials_charges_require_sku_and_count
  validate  :untaxable_methods_cannot_be_taxable
  # validates :semester_code, presence: true

  default_scope { order(created_at: :desc) }

  scope :unpaid,     -> { where(paid_at: nil) } 
  scope :paid,       -> { where("paid_at IS NOT NULL") } 
  scope :ufid,       -> { where("payment_method = ?", UFID_PAYMENT) } 
  scope :check,      -> { where("payment_method = ?", CHECK_PAYMENT) } 
  scope :chartfield, -> { where("payment_method = ?", CHARTFIELD_PAYMENT) } 
  scope :comped,     -> { where("payment_method = ?", COMPED_PAYMENT) } 
  scope :not_comped, -> { where("payment_method != ?", COMPED_PAYMENT) } 

  scope :dcp,        -> { joins(:account).where('accounts.affiliation = ?', Account::ARCH_AFFILIATION) }
  scope :arts,       -> { joins(:account).where('accounts.affiliation = ?', Account::ARTS_AFFILIATION) }
  scope :uf,         -> { joins(:account).where('accounts.affiliation = ?', Account::UF_AFFILIATION) }
  scope :external,   -> { joins(:account).where('accounts.affiliation IS NULL') }

  scope :print,      -> { where("charge_type = ?", PRINT_CHARGE) } 
  scope :cnc,        -> { where("charge_type = ?", CNC_CHARGE) } 
  scope :waterjet,   -> { where("charge_type = ?", WATERJET_CHARGE) } 
  scope :membership, -> { where("charge_type = ?", MEMBERSHIP_CHARGE) } 
  scope :laser,      -> { where("charge_type = ?", LASER_CHARGE) } 
  scope :design,     -> { where("charge_type = ?", DESIGN_CHARGE) } 
  scope :materials,  -> { where("charge_type = ?", MATERIALS_CHARGE) } 

  scope :created_after, ->(date) { where("charges.created_at > ?", date) } 
  scope :created_before,  ->(date) { where("charges.created_at < ?", date) } 

  scope :taxable,  -> { where("is_taxable = ?", true) } 

  def display_charge_type
    if charge_type == PRINT_CHARGE
      "3D Print"
    elsif charge_type == CNC_CHARGE
      "CNC Cut"
    elsif charge_type == WATERJET_CHARGE
      "Waterjet Cut"
    elsif charge_type == MEMBERSHIP_CHARGE
      "Membership"
    elsif charge_type == LASER_CHARGE
      "Laser Cut"
    elsif charge_type == DESIGN_CHARGE
      "Design/Fabrication"
    elsif charge_type == MATERIALS_CHARGE
      "Materials"
    else
      ""
    end
  end

  def charge_string
    if charge_type == PRINT_CHARGE
      "321000000002"
    elsif charge_type == CNC_CHARGE
      "321000000006"
    elsif charge_type == WATERJET_CHARGE
      "321000000005"
    elsif charge_type == MEMBERSHIP_CHARGE
      "321000000001"
    elsif charge_type == LASER_CHARGE
      "321000000003"
    elsif charge_type == DESIGN_CHARGE
      "321000000007"
    elsif charge_type == MATERIALS_CHARGE
      "321000000004"
    else
      "321000000004"
    end
  end


  def display_payment_method
    if payment_method == UFID_PAYMENT
      "UFID"
    elsif payment_method == CHARTFIELD_PAYMENT
      "Chartfield"
    elsif payment_method == CHECK_PAYMENT
      "Check"
    elsif payment_method == COMPED_PAYMENT
      "Not Charged/Comped"
    end
  end

  def pay!
    self.update_attribute(:paid_at, Time.now)
  end

  def paid?
    self.paid_at.present?
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
  
  def charges_on_external_accounts_must_be_check
    if(payment_method != CHECK_PAYMENT && self.account.account_type == Account::EXTERNAL_CLIENT_TYPE)
      errors.add(:base, "Charges for external clients must be paid by check.")
    end
  end

  def chartfield_payments_require_chartfield_on_account
    if payment_method == CHARTFIELD_PAYMENT
      errors.add(:base, "Must add chartfield account number to this account before charge can be added.") unless self.account.chartfield.present?
    end
  end

  def ufid_payments_require_ufid_on_account
    if payment_method == UFID_PAYMENT
      errors.add(:base, "Must add UFID to this account before charge can be added.") unless self.account.ufid.present?
    end
  end

  def add_time_to_account_if_membership_charge
    if self.charge_type == Charge::MEMBERSHIP_CHARGE && self.membership_id.present?
      m = self.membership

      # add time to existing if 
      if self.account.expires_at.blank? || self.account.expires_at < Time.now
        self.account.update_attribute(:expires_at, Time.now + m.duration.days)
      else
        self.account.update_attribute(:expires_at, self.account.expires_at + m.duration.days)
      end
    end
  end

  # applies credit towards new payments, if credit exists
  def deduct_from_credit
    if self.account.has_credit? && self.payment_method != Charge::COMPED_PAYMENT
      credit_amount_string = ActionController::Base.helpers.number_to_currency(self.account.credit)
      charge_amount_string = ActionController::Base.helpers.number_to_currency(self.amount)

      # credit > charge
      # subtract charge amount from credit amount, pay charge completely
      if self.account.credit >= self.amount
        self.update_attribute(:payment_method, Charge::COMPED_PAYMENT)
        self.update_attribute(:paid_at, Time.now)
        self.update_attribute(:description, self.description + " (#{charge_amount_string} paid by lab credit)")
        self.account.update_attribute(:credit, self.account.credit - self.amount)


      # charge > credit: 
      # split charge into two charges -- covered by credit and not covered
      # pay charge covered by credit
      else
        paid_amount   = self.account.credit 
        unpaid_amount = self.amount - self.account.credit

        self.account.update_attribute(:credit, 0)

        Charge.create(amount: paid_amount, 
                      payment_method: Charge::COMPED_PAYMENT,
                      paid_at: Time.now,
                      charge_type: self.charge_type,
                      account: self.account,
                      description: "Parital lab credit payment (original charge #{charge_amount_string}, #{credit_amount_string} paid by lab credit)" 
                      )

        self.update_attribute(:amount, unpaid_amount)
        self.update_attribute(:description, self.description + " (original charge #{charge_amount_string}, #{credit_amount_string} paid by lab credit)")
      end
    end
  end

  def materials_charges_require_sku_and_count
    if self.charge_type == Charge::MATERIALS_CHARGE
      errors.add(:base, "Materials charges require an SKU") unless self.material_sku.present?
      errors.add(:base, "Materials charges require a quantity") unless self.material_count.present?

      unless (self.material_count.class == Fixnum || 
             self.material_count =~ /^[1234567890]+$/ ) &&
              self.material_count > 0
        errors.add(:base, "Materials quantity must be a positive number") 
      end

      errors.add(:base, "Material SKU #{self.material_sku} does not exist.") unless Material.sku(self.material_sku).count > 0
    end
  end

  def untaxable_methods_cannot_be_taxable
    if (self.payment_method == Charge::CHARTFIELD_PAYMENT || 
       self.payment_method == Charge::COMPED_PAYMENT) && self.is_taxable == true
      errors.add(:base, "Chartfield and Comped charges cannot be taxable.")
    end
  end

  # if this charge is associated with a materials purchase, 
  # decrement the count for that material
  # if this is a materials charge, then count and quantity are guaranteed to be 
  # present
  def deduct_inventory_counts
    if self.charge_type == Charge::MATERIALS_CHARGE
      material = Material.sku(self.material_sku).first

      if material
        old_count = material.count.nil? ? 0 : material.count

        material.update_attribute(:count, old_count -= self.material_count)
      end
    end
  end

  def fill_details_via_membership_id
    if self.membership_id.present?
       membership = Membership.find(self.membership_id)

      self.amount = membership.price 
      self.description = membership.name
      self.charge_type = Charge::MEMBERSHIP_CHARGE
    end
  end

  def set_comped_charges_to_paid
    if self.payment_method == Charge::COMPED_PAYMENT
      self.paid_at = Time.now
    end
  end

  def calculate_tax
    if self.tax_charge.nil?
      if is_taxable
        self.subtotal = self.amount
        self.tax_charge = self.amount * TAX_RATE
        self.amount = self.subtotal + self.tax_charge
      else
        self.subtotal = self.amount
        self.tax_charge = 0.0
      end
    end
  end
end
