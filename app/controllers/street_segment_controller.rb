class StreetSegmentController < ApplicationController

	def index
		if (params["precinct"])
			@precinct = Precinct.find(params["precinct"])
			@street_segments = @precinct.street_segments
			add_crumb "Source", @precinct.source
			add_crumb "State", @precinct.locality.state
			add_crumb "Locality", @precinct.locality
			add_crumb "Precinct", @precinct
			add_crumb "Street Segments"
		elsif (params["precinct_split"])
			@precinct_split = PrecinctSplit.find(params["precinct_split"])
			@precinct = @precinct_split.precinct
			@street_segments = @precinct_split.street_segments
			add_crumb "Source", @precinct.source
			add_crumb "State", @precinct.locality.state
			add_crumb "Locality", @precinct.locality
			add_crumb "Precinct", @precinct
			add_crumb "Split", @precinct_split
			add_crumb "Street Segments"
		elsif (params["source"])
			@source = Source.find(params["source"])
			@street_segments = @source.street_segments
			add_crumb "Source", @source
			add_crumb "Street Segments"
# this would probably crash something
#		else
#			@street_segments = StreetSegment.find(:all)
		end
	end
end
