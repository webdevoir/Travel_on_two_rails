class DonationGoal < ApplicationRecord
  belongs_to :trip
  has_many :purchases
  has_many :buyers, through: :purchases
end
