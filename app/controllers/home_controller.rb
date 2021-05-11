require 'uri'
class HomeController < ApplicationController
	def index
		 @mvc = Mvc.find(1)
   config = """{
  type: 'pie',
  data: {
    labels: ['model', 'view', 'controller'],
    datasets: [{
      label: 'Data',
      data: [ 2, 8, 2]
    }]
  }
}"""

encoded = URI.encode_www_form_component(config.strip)

# Output a URL to my image
@hello = "https://quickchart.io/chart?c=#{encoded}" 
		@mvc = Mvc.find(1)
  	puts params.inspect
  end

end
