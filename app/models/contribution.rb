class Contribution < ActiveRecord::Base
  belongs_to :user

  validates :amount, numericality: {greater_than: 0}, presence: true
end
