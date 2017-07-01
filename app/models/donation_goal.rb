class DonationGoal < ApplicationRecord
  has_one :trip
  has_many :purchases
  has_many :buyers, through: :purchases
end
