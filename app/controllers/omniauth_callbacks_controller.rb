class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	##Handle the callback from provider (facebook/twitter)
	#Parameters::(Hash) Authentication Hash contains info returned from provider
	#Return::None
	#Author::ChienTX
	def facebook
		handle_omniauth_callback(request.env['omniauth.auth'])
	end


	##Handle the callback from provider (facebook/twitter)
	#Parameters::(Hash) Authentication Hash contains info returned from provider
	#Return::None
	#Author::ChienTX
	def twitter
		handle_omniauth_callback(request.env['omniauth.auth'])
	end

private
	##Handle the callback from provider (facebook/twitter)
	#Parameters::(Hash) Authentication Hash contains info returned from provider
	#Return::None
	#Author::ChienTX
	def handle_omniauth_callback(auth)
    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
    provider = auth['provider'] || 'Unknown'

    ## data of facebook
    # info=#<OmniAuth::AuthHash::InfoHash email="phanhoanglong2610@gmail.com"
    # first_name="Long" image="http://graph.facebook.com/100000709457324/picture?type=square"
    # last_name="Phan-Hoàng" location="Ho Chi Minh City, Vietnam" name="Long Phan-Hoàng"
    # nickname="phanhoanglong2610"
    # urls=#<Hashie::Mash Facebook="http://www.facebook.com/phanhoanglong2610">
    # verified=true> provider="facebook" uid="100000709457324"

    if authentication

      # sign in and direct to previous page
      sign_in_and_redirect authentication.user, :event => :authentication
      set_flash_message(:notice, :success, :kind => auth["facebook"]) if is_navigational_format?

    else
      # Authentication not found, thus a new user.
      @user = User.new

      # temp for username social accounts such as Twitter

      #prefill with info from provider website
      @user.apply_omniauth(auth)

      @info = {
      	:first_name => @user.first_name,
      	:last_name => @user.last_name,
      	:email => @user.email
      }

      session["devise.#{auth["provider"]}_data"] = auth.except("extra")

      render :template => "devise/registrations/new"
    end
	end
end