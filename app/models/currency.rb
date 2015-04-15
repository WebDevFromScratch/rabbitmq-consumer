class Currency < ActiveRecord::Base
  validates :uuid, presence: true
  validates :rates, presence: true
end
