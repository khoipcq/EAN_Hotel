class HomeController < ApplicationController
  ## preprocessor
  skip_before_filter :verify_authenticity_token, :only => [:index, :search]
  ## define contants

  ## relationship


  ##
  #render homepage
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::json data
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def index
    ##TODO: render homepage of customer
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @homes }
    end
  end

  ##
  #render test homepage
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::json data
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def test
    ##TODO: render test homepage with menus
    respond_to do |format|
      format.html # test.html.erb
      format.xml  { render :xml => @homes }
    end
  end

  ##
  #get subregion based-on user's country select
  #Parameters::
  # (String) *country_code*: country_code of user's select
  #Return::json data
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def subregion_options
    render partial: 'subregion_select'
  end


  ##
  #search result for autocomplete
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::json data
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def search
    ##TODO: search engine for autocomplete
    raw_search_str = params['s'].to_s.downcase || ''
    search_str = raw_search_str.gsub(/(:|@|-|!|'|~|&|"|\/|\(|\)|\\|\|)/){ "\\#{$1}" }

    @data = home_service.search(search_str, raw_search_str)

    respond_to do |format|
      format.json { render :json => @data}
      format.html # index.html.erb
      format.xml  { render :xml => @homes }
    end
  end

  protected
  ##
  #Get or create an instance of HomeService class
  #Return::
  #An instance of HomeService class
  #*Author*::LongPH
  def home_service
    @home_service ||= HomeService.new
  end
end
