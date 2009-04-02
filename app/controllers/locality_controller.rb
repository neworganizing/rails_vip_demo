class LocalityController < ApplicationController

	def show
		@locality = Locality.find(params[:id])
		add_crumb "Source", @locality.source
		add_crumb "State", @locality.state
		add_crumb "Locality"
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@localities = @source.localities
			add_crumb "Source", @source
			add_crumb "State", @localities.first.state
			add_crumb "Localities"
		else
			@localities = Locality.find(:all)
			add_crumb "Localities"
		end
	end
end
