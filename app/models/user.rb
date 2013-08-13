class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :provider, :uid, :first_name, :last_name, :gender

  validates_presence_of :first_name, :last_name, :gender
  has_many :authentications, :dependent => :delete_all
  has_many :roles

  # Scope for find all user, expect user with specified ID
  scope :id_not, lambda { |except_id| where(["id <> ?", except_id])}

  ##
  #Get user list except an user with specify ID
  #Parameters::
  # * (Integer) *id*: id want to be ignored
  # * (Integer) *page*: current page
  # * (Integer) *per_page*: items amount per page
  #Return::
  # * (Array) Matched user list with paging
  #*Author*:: ChienTX
  def self.get_all_users_except_id(id, page, per_page)
    users = id_not(id).paginate(:page => page, :per_page => per_page)
  end

  ##Return list of roles
  def role_symbols
    user_roles = (self.roles || []).map{|r| r.title.to_sym}
    if user_roles.length == 0
      user_roles << :user
    end

    user_roles
  end

  ## public methods
  def apply_omniauth(auth)
    # In previous omniauth, 'user_info' was used in place of 'raw_info'
    self.email = auth['extra']['raw_info']['email']
    self.first_name = auth['info']['first_name']
    self.last_name = auth['info']['last_name']
    # Again, saving token is optional.
    #If you haven't created the column in authentications table, this will fail
    authentications.build(
      :provider => auth['provider'],
      :uid => auth['uid'],
      :token => auth['credentials']['token']
      )

  end

  ##
  #Create a new user with data from other website (facebook, twitter...)
  #Parameter::
  # (Hash) *params* params sent to controller
  # (Hash) *session* session variable
  #Return::
  #*Author*::ChienTX
  def self.new_with_session(params, session)
    super.tap do |user|
      data  = session["devise.facebook_data"] || session["devise.twitter_data"]

      unless data.nil?
        user.authentications.build(
          :provider => data['provider'],
          :uid => data['uid'],
          :token => data['credentials']['token']
          )
      end
    end
  end

  ##
  #Check whether this user is disabled or not
  #Parameter::
  #Return:: (Boolean) user is active
  #*Author*::ChienTX
  def active?
    !!active
  end

  ##
  #Message to inform user that his/her account has been disabled
  #Parameter::
  #Return:: (String) message
  #*Author*::ChienTX
  def inactive_message
    if confirmed?
      I18n.t("users.account_disabled")
    else
      super
    end
  end

  ##
  #Check for user status before he can log in
  #Parameter::
  #Return:: (Boolean) Whether or not user can log in
  #*Author*::ChienTX
  def active_for_authentication?
    return super && active?
  end

  ##
  #Enable user
  #Parameter::
  #Return::
  #*Author*::ChienTX
  def activate!
    self.active = true
    self.save
  end

  ##
  #Disable user
  #Parameter::
  #Return::
  #*Author*::ChienTX
  def deactivate!
    self.active = false
    self.save!
  end

end
