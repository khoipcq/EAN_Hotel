class Currency < ActiveRecord::Base
  attr_accessible :CurrencyCode, :CurrencyDescription

  scope :in_ague, where("CurrencyCode IN ('USD','EUR','GBP','AUD')").limit(10) 
end
