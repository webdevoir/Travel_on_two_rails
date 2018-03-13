class SavedRoute < ApplicationRecord

  belongs_to :route
  belongs_to :user
end
