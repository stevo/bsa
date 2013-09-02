class Contribution < ActiveRecord::Base
  validates :amount, numericality: {greater_than: 0}, presence: true
end
