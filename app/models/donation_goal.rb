class DonationGoal < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :trip
  has_many :purchases
  has_many :buyers, through: :purchases

  validates :amount, :title, :end_date, presence: true
end
