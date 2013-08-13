#=== ApplicationHelper
#*Author*::LongPH
#------------------------------------------------------------------------------
# Methods added to this helper will be available to all templates in the application.
require 'application_constants'
require 'digest/md5'
require 'cgi'

module ApplicationHelper

  ## preprocessor
  include ApplicationConstants

  WS_URL      =  "http://api.ean.com/ean-services/rs/hotel/v3/"
  WS_URL_POST =  "https://book.api.ean.com/ean-services/rs/hotel/v3/"
  WS_KEY      =  "?cid=55505&apiKey=6wrtmp9t9j7zbxyx6b4he955"

  ##
  #return cid of user, '55505' for Developer Free Account
  #Parameters::
  #Return::cid
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_cid
    return '55505'
  end

  ##
  #return apiKey, default is of LongPH
  #Parameters::
  #Return::api Key
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_apiKey
    return 'wbf3wr553fuaevgju4ekyng9'
  end

  ##
  #return apiKey secret key, default is of LongPH
  #Parameters::
  #Return::api Key
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_shared_key
    return 'yU4ngxFa'
  end

  ##
  #return Digital Signature, default is of LongPH
  #Parameters::
  #Return::Digital Signature
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_sig
    # Your credentials
    api_key = get_apiKey
    shared_secret_key = get_shared_key
    api_version = 'v3'

    current_time = Time.now
    timestamp = Time.now.to_i.to_s
    sig = Digest::MD5.hexdigest( api_key + shared_secret_key + timestamp )
    sig
  end

  ##
  #return web_service_url from EAN for GET request
  #Parameters::
  # (String) *action*: action of request
  #Return::url of webservice
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def web_service_url(action)
    return  WS_URL + action.to_s + WS_KEY
  end

  ##
  #return web_service_url from EAN for POST request
  #Parameters::
  # (String) *action*: action of request
  #Return::url of webservice
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def web_service_url_post(action)
    return  WS_URL_POST + action.to_s
  end

  ##
  #strip tags from text
  #Parameters::
  # (String) *html*: text from string
  #Return::plain text with no tags
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def strip_tags(html)
    if html.nil?
      stripped_html = nil
    else
      stripped_html = html.gsub(/<\/?[^>]*>/, '').gsub(/\n\n+/, "\n").gsub(/^\n|\n$/, '')
    end
    stripped_html
  end

  ##
  #display HTML string with full markup
  #Parameters::
  # (String) *html*: plain text
  #Return::HTML string with full markup
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def display_html(html)
    return "N/A" if (html.nil? or html.blank?)
    begin
      CGI.unescapeHTML(html)
    rescue => exception
      p exception
    end
  end
  def display_button()
    return "<span class=\"btn btn-small btn-primary span8\" value=\"Select Hotel\" style=\"padding-top: 5px \" id=\"btn-check-rooms\">Select Hotel</span>".html_safe
  end
  def display_booking_button()
    return "<input type=\"button\" class=\"btn btn-small btn-primary span8\" value=\"Book now\" style=\"padding-top: 5px \" id=\"book-btn\">".html_safe
  end
  ##
  #display Y/N based on boolean value
  #Parameters::
  # (String) *string*: 'true' or 'false'
  #Return::'yes' or 'no'
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def display_require(string)
    return "Yes"  if (string == "true"  || string == true)
    return "No"   if (string == "false" || string == false)
  end

  ##
  #display HTML string with full markup
  #Parameters::
  # (String) *phrase*: plain text
  # (String) *search_words*: keywords to be searched
  #Return::HTML string with highlighted keywords
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def highlight_words(phrase, search_words)

    ## boundary checking
    if (phrase.nil? || search_words.nil?)
      return ""
    end

    return_phrase = phrase
    tmp = []
    phrase.split(" ").each do |x|
      unmatch = nil
      search_words_temp = search_words
      
      search_words = search_words.gsub(/(:|@|-|!|'|~|&|"|\/|\(|\)|\\|\|)/, " ")
      new_search_words = search_words.split(' ')
      new_search_words << search_words_temp
      new_search_words.sort {|u,v| v.length <=> u.length}.each do |word|
        word = Regexp.escape(word)
        rexp = /#{word}/i
        x.scan(rexp).uniq.each do |matched|
          escaped_matched = Regexp.escape(matched)
          #escaped_matched.gsub!('\\','') if escaped_matched.include?('\\')
          unmatch = x.gsub!(/^#{escaped_matched}/, "<span class='highlighted'>#{matched}</span>")
          if unmatch.nil?
            unmatch = x.gsub!(/-#{escaped_matched}/, "-<span class='highlighted'>#{matched}</span>")
          end
          if unmatch.nil?
            unmatch = x.gsub!(/\(#{escaped_matched}/, "(<span class='highlighted'>#{matched}</span>")
          end
          break if unmatch
        end
        # case word in (word) or -word
        if x.scan(rexp).empty?
          word.gsub!('(','') if word.include?('(')
          word.gsub!(')','') if word.include?(')')
          word.gsub!('-','') if word.include?('-')
          #word = Regexp.escape(word)
          word.gsub!('\\','') if word.include?('\\')
          rexp = /#{word}/i
          x.scan(rexp).uniq.each do |matched|
            escaped_matched = Regexp.escape(matched)
            unmatch = x.gsub!(/#{escaped_matched}/, "<span class='highlighted'>#{matched}</span>")
            break if unmatch
          end
        end
        break if unmatch
      end
      tmp << x
    end
    return tmp.join(" ")
  end

  ## for Devise
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  ##list of genders for display on view
  #Author:: ChienTX
  def genders_select
    return [['Male', 'm'], ['Female', 'f'], ['Unspecified', 'u']]
  end

  def render_long_email(email)
    if email.length < 32
      email
    else
      email[0..32] + "..."
    end
  end
end


module JSON
  def is_json?(string)
    begin
      parse(string).all? # will return true
    rescue ParserError
      false
    end
  end
end

class String
  def uncapitalize
    self[0, 1].downcase + self[1..-1]
  end
end