class ElectionController < ApplicationController

	def show
		@election = Election.find(params[:id])
		add_crumb "Source", @election.source
		add_crumb "Election"
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@elections = @source.elections
			add_crumb "Source", @election.source
			add_crumb "Elections"
		else
			@elections = Election.find(:all)
			add_crumb "Elections"
		end
	end
end
