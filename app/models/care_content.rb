class CareContent < ApplicationRecord
  belongs_to :user
  has_many :emergency_contacts, dependent: :destroy

  accepts_nested_attributes_for :emergency_contacts, allow_destroy: true
  # serialize :phone_numbers, Array
end
