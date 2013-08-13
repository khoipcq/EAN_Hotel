class PasswordsController < ApplicationController
	before_filter :authenticate_user!

  ##
  #Render page to allow users edit their password
  #Parameters::
  #Return:: Views
  #*Author*::ChienTX
  def edit
    @user = current_user
  end
  
  ##
  #Update user password
  #Parameters:: (Hash) *params* user information with following fields
  # => (String) *current_password*: current user password
  # => (String) *password* new password
  # => (String) *confirmation_password* 
  #Return:: Views
  #*Author*::ChienTX
  def update
    @user = current_user
    if @user.update_with_password(params[:user])
      if is_navigational_format?
        flash[:notice] = t("passwords.update.success")
      end
      sign_in @user, :bypass => true
      redirect_to edit_user_registration_path
    else
      flash[:error] = t("passwords.update.failed")
      redirect_to :action => :edit
    end
  end
end
