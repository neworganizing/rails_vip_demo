class ElectionOfficialController < ApplicationController

	def show
		@election_official = ElectionOfficial.find(params[:id])
		add_crumb "Source", @election_official.source
		#TODO: handle crumb from request
		add_crumb "Election Official"
	end

	def index
		if (params["source"])
			source = Source.find(params["source"])
			@election_officials = source.election_officials
			add_crumb "Source", source
			add_crumb "Election Officials"
		else
			@election_officials = ElectionOfficial.find(:all)
			add_crumb "Election Officials"
		end
	end
end
