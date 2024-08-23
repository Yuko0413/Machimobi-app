class CareContent < ApplicationRecord
  belongs_to :user

  serialize :phone_numbers, Array
end
