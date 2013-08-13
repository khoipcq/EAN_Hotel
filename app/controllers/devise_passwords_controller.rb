class DevisePasswordsController < Devise::PasswordsController
   # GET /resource/password/edit?reset_password_token=abcdef
  skip_before_filter :require_no_authentication, :only => :edit
  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
  end
  
end