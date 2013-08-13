class GdsAttributeList < ActiveRecord::Base
  attr_accessible :AttributeDesc, :AttributeID, :LanguageCode, :SubType, :Type
end
