class HomeController < ApplicationController
	def index
		@mvc = Mvc.find(1)
  	puts params.inspect
  end

end
