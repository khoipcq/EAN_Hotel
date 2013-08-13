class Category < ActiveRecord::Base
  attr_accessible :name, :code, :description, :type
end
