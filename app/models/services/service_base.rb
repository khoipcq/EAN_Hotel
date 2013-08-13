##
#=== BaseService for other services
#*Author*::LongPH
#------------------------------------------------------------------------------
require 'application_constants'
require 'net/http'
require 'net/https'
require 'open-uri'
require 'service_helper'

class ServiceBase

  ## preprocessor
  include ApplicationHelper
  include ApplicationConstants
  include ServiceHelper
  include ReservationsHelper
end
