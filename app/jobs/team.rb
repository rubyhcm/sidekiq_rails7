class Team < ApplicationRecord
  validates :name, presence: true
  validates :rating, presence: true
end
