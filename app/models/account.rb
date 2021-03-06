# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  email         :string(255)
#  first_name    :string(255)
#  last_name     :string(255)
#  business_name :string(255)
#  phone         :string(255)
#  gatorlink_id  :string(255)
#  chartfield    :string(255)
#  affiliation   :integer
#  account_type  :integer
#  expires_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#  ufid          :string(255)
#  uf_college    :string(255)
#  credit        :float(24)
#

class Account < ApplicationRecord
  acts_as_paranoid
  audited

  UF_AFFILIATION = 1
  ARCH_AFFILIATION = 2

  # The constant A2_AFFILICATION is depreciated. Used to mean Arts + Arch, now a synonym for Arch. Kept here to avoid bugs where A2_AFFILIATION is undefined, especially in old migrations.

  A2_AFFILIATION = 2 
  ARTS_AFFILIATION = 3

  LASER_MEMBER_TYPE = 1
  INTERNAL_CLIENT_TYPE = 2
  EXTERNAL_CLIENT_TYPE = 3
  STAFF_TYPE = 4

  has_many :charges

  attr_accessor :auto_charge

  # account rules:

  # all accounts must have a type
  # all accounts must have email
  # all accounts must have either first and last name, or business name
  # Laser members must have UF or A2 affiliation
  # UF clients members must have UF or A2 affiliation
  # External clients must have no affiliation
  # External clients must have no gatorlink
  # UF and A2 affiliates must have a Gatorlink ID
  # Gatorlink IDs must be unique

  # TODO: laser accounts must have expiration
  # TODO: staff accounts must have expiration

  validates :account_type, presence: true
  validates :email, presence: true
  validates :gatorlink_id, uniqueness: true, allow_blank: true
  validates :ufid, uniqueness: true, allow_blank: true
  
  validate :has_either_personal_or_business_name
  validate :has_affiliation_if_laser
  validate :has_affiliation_if_internal_client
  validate :has_no_affiliation_if_external_client
  validate :has_no_gatorlink_if_external_client
  validate :has_gatorlink_id_with_affiliation
  validate :has_no_ufid_if_external_client
  validate :ufid_is_8_digits

  before_create :add_membership_charge

  default_scope { order(created_at: :desc) }

  scope :recent_laser, -> { where("account_type = ? && created_at > ?", 
    LASER_MEMBER_TYPE,
    2.days.ago)}

  scope :uncharged_laser, -> { where(expires_at: nil, account_type: LASER_MEMBER_TYPE) }

  scope :active_laser, -> { where("expires_at > ?", 
    Time.now)}

  scope :expired_laser, -> { where("account_type = ? && expires_at < ?", 
    LASER_MEMBER_TYPE,
    Time.now)}

  scope :lab_credit, -> { where("credit > 0")}

  scope :filter, ->(q) { where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR gatorlink_id LIKE ? OR business_name LIKE ? OR ufid LIKE ?", 
                        "%#{q}%", 
                        "%#{q}%", 
                        "%#{q}%", 
                        "%#{q}%", 
                        "%#{q}%", 
                        "%#{q}%") }

  def display_name
    if business_name.present?
      business_name
    else
      first_name + " " + last_name
    end
  end

  def display_affiliation
    if affiliation == UF_AFFILIATION
      "University of Florida"
    elsif affiliation == ARCH_AFFILIATION
      "DCP"
    elsif affiliation == ARTS_AFFILIATION
      "Arts"
    else
      ""
    end
  end

  def display_account_type
    if account_type == LASER_MEMBER_TYPE
      "Laser Member"
    elsif account_type == INTERNAL_CLIENT_TYPE
      "UF Client"
    elsif account_type == EXTERNAL_CLIENT_TYPE
      "External Client"
    elsif account_type == STAFF_TYPE
      "Staff"
    else
      ""
    end
  end

  def display_expiration_date
    if expires_at.present?
      expires_at.strftime("%m/%d/%Y")
    else
      ""
    end
  end

  def active?
    expires_at.present? ? Time.now < expires_at : false
  end

  def uf_affiliated?
    affiliation.present?
  end

  def has_credit?
    credit && credit > 0
  end  

  protected

  def has_either_personal_or_business_name
    if (first_name.blank? || last_name.blank?) && business_name.blank?
      errors.add(:first_name, ": Full name or Business name required.")
      errors.add(:last_name, ": Full name or Business name required.")
      errors.add(:business_name, ": Full name or Business name required.")
    end
  end

  def has_affiliation_if_laser 
    if account_type == LASER_MEMBER_TYPE && affiliation.blank?
      errors.add(:affiliation, " required for laser accounts")
    end
  end

  def has_affiliation_if_internal_client
    if account_type == INTERNAL_CLIENT_TYPE && affiliation.blank?
      errors.add(:affiliation, " required for internal client accounts")
    end
  end

  def has_no_affiliation_if_external_client
    if account_type == EXTERNAL_CLIENT_TYPE && affiliation.present?
      errors.add(:affiliation, " must be blank for external clients")
    end
  end

  def has_no_gatorlink_if_external_client
    if account_type == EXTERNAL_CLIENT_TYPE && gatorlink_id.present?
      errors.add(:gatorlink_id, " must be blank for external clients")
    end
  end

  def has_gatorlink_id_with_affiliation
    if (affiliation == UF_AFFILIATION || affiliation == ARCH_AFFILIATION || affiliation == ARTS_AFFILIATION) && gatorlink_id.blank? && account_type != EXTERNAL_CLIENT_TYPE
      errors.add(:gatorlink_id, " required")
    end
  end

  def has_no_ufid_if_external_client
    if account_type == EXTERNAL_CLIENT_TYPE && ufid.present?
      errors.add(:ufid, " must be blank for external clients")
    end
  end

  def add_membership_charge
    if self.account_type == LASER_MEMBER_TYPE && self.auto_charge == true
      membership = Membership.affiliation(self.affiliation).new_memberships.first

      self.charges << Charge.new(charge_type: Charge::MEMBERSHIP_CHARGE,
                                 payment_method: Charge::UFID_PAYMENT,
                                 membership_id: membership.id,
                                 amount: membership.price,
                                 description: membership.name)

    end
  end

  def ufid_is_8_digits
    if self.ufid.present?
      errors.add(:ufid, " must be 8 digits") unless self.ufid =~ /\d{8}/ && self.ufid.length == 8
    end
  end
end
