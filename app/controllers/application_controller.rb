# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'open-uri'
require 'json'
require 'cgi'
require 'application_constants'
require 'service_helper'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  ## preprocessor
  include ServiceHelper
  include ReservationsHelper
  ## filter
  before_filter :set_current_user

  ##Set the current logged in user (required by declarative_authorization gem)
  def set_current_user
    Authorization.current_user = current_user
  end

  protected

  ##
  #check whether a user logged in or not
  #Parameters::
  #Return::redirect to login page if not logged in
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def authorize
    unless User.find_by_id(session[:user_id]) or User.count == 0
      session[:original_uri] = request.request_uri
      flash[:notice] = t("layouts.application.please_login")
      redirect_to(:controller=>"admin", :action=>"login")
    end
    if User.count == 0
      if request.path_parameters[:action]=="add_user" and request.path_parameters[:controller]=="login"
        #As we are already on our way to the add_user action, do nothing here.
      else
        flash[:notice] = t("layouts.application.please_create_account")
        redirect_to(:controller=>"login", :action=>"add_user")
      end
    end
  end

  def permission_denied
    redirect_to root_path
  end

end
