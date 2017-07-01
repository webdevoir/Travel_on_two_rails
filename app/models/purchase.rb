class Purchase < ApplicationRecord
  belongs_to :donation_goal
  belongs_to :buyer, class_name: 'User'
end
