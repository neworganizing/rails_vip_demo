class ElectionAdministrationController < ApplicationController

	def show
		@election_administration = ElectionAdministration.find(params[:id])
		add_crumb "Source", @election_administration.source
		#TODO: add crumbs for how we got here
		add_crumb "Election Administration"
		url = URI.parse(request.referer)
		route = ActionController::Routing::Routes.recognize_path(url)
		puts url
	end

	def index
		if (params["source"])
			source = Source.find(params["source"])
			@election_administrations = source.election_administrations
		else
			@election_administrations = ElectionAdministration.find(:all)
		end
	end
end
