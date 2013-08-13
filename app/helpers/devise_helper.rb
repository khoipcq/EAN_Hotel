module DeviseHelper
	def devise_error_messages!
      return "" if resource.errors.empty?
      resource.errors.full_messages.map{|msg| flash.now[:error] = msg}.join
      return ""
	end
end