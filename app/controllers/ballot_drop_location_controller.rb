class BallotDropLocationController < ApplicationController

	def show
		@ballot_drop_location = BallotDropLocation.find(params[:id])
		add_crumb "Source", @ballot_drop_location.source
		add_crumb "State", @ballot_drop_location.locality..state
		add_crumb "Locality", @ballot_drop_location.locality
		add_crumb "Ballot Drop Location"
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@ballot_drop_locations = @source.ballot_drop_locations
			add_crumb "Ballot Drop Locations"
		elsif (params["locality"])
			@locality = Locality.find(params["locality"])
			@ballot_drop_locations = @locality.ballot_drop_locations
			add_crumb "State", @locality.state
			add_crumb "Locality", @locality
			add_crumb "Ballot Drop Locations"
		else
			@ballot_drop_locations = BallotDropLocations.find(:all)
			add_crumb "Ballot Drop Locations"
		end
	end
end
