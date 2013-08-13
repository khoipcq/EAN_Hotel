class Authentication < ActiveRecord::Base
  ## Config attributes
  attr_accessible :provider, :token, :uid, :user_id

  ## Relationships
  belongs_to :user

end
