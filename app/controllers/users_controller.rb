#=== UsersController
#*Author*::LongPH
#--------------------------------------------------------
class UsersController < ApplicationController

  ## authorization
  filter_access_to :all
  filter_access_to :change_password, :attribute_check => false

  #get user based on   
  before_filter :get_user, only: [:show, :edit, :update, :destroy, :reset_password, 
                                  :enable_user, :disable_user]

  def get_user
    @user = User.find(params[:id])
  rescue
    if request.xhr? #This is ajax request
      render json: {text: t("message.not_found")}
    else
      render text: t("message.not_found")
    end
  end


  ##
  #Display list of users (except current user)
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::
  #*Author*::ChienTX
  #----------------------------------------------------------------------------
  def index
    page = params[:page] || ENV["PAGE"].to_i
    per_page = params[:per_page] || ENV["PER_PAGE"].to_i

    @users = User.get_all_users_except_id(current_user.id, page, per_page)
                 .order("first_name ASC")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  ##
  #Display list of users (except current user)
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::
  #*Author*::ChienTX
  #----------------------------------------------------------------------------
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  ##
  #Render view to create new user
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::
  #*Author*::ChienTX
  #----------------------------------------------------------------------------
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  ##
  #Render view to edit user information
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::
  #*Author*::ChienTX
  #----------------------------------------------------------------------------
  def edit
    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  # POST /users.xml
  def create
    password = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]

    @user = User.new(params[:user])

    status = @user.save

    respond_to do |format|
      if status
        format.html { redirect_to(users_url, :notice => t("users.create.success")) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(users_url, :notice => t("users.update.success")) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  ##
  #Destroy user
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::
  #*Author*::ChienTX
  #----------------------------------------------------------------------------
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end


  ##Send an email with instructions to help user reset their password
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::
  #*Author*::ChienTX
  #----------------------------------------------------------------------------
  def reset_password
    @user.send_reset_password_instructions
    flash.notice = t("users.reset_password.email_sent")

    respond_to do |format|
      format.html {redirect_to(users_url)}
      format.xml {head :ok}
    end
  end

  ##
  #Enable an user
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::HTML view
  #*Author*::ChienTX
  #----------------------------------------------------------------------------
  def enable_user
    @user.activate!
    respond_to do |format|
      format.html {redirect_to(users_url)}
    end
  end

  ##
  #disable an user
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::HTML view
  #*Author*::ChienTX
  #----------------------------------------------------------------------------
  def disable_user
    @user.deactivate!
    respond_to do |format|
      format.html {redirect_to(users_url)}
    end
  end

end
