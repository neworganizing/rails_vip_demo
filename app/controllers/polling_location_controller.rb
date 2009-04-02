class PollingLocationController < ApplicationController

	def show
		require 'rubygems'
		require 'google_geocode'
		@title = "Polling Location"
		@polling_location = PollingLocation.find(params[:id])
		gg = GoogleGeocode.new "ABQIAAAAu7Re6QJVDQ3U5Sp2u2w3UhSwMyR9mQOTO__cwzDlnGLWnDHQaxQofqAx35lKdPCM1ODtbttHZKOR3Q"	

		address_versions = []
		address_versions.push @polling_location.address
		if @polling_location.precincts.first.street_segments.size > 0
			address_versions.push @polling_location.name    + ', ' + \
			                      @polling_location.address + ', ' + \
			                      @polling_location.precincts.first.street_segments.first.start_street_address.city + ', ' + \
			                      @polling_location.precincts.first.locality.state.name 
			address_versions.push @polling_location.name    + ', ' + \
			                      @polling_location.address + ', ' + \
			                      @polling_location.precincts.first.street_segments.first.start_street_address.city + ', ' +
			                      @polling_location.precincts.first.locality.state.name
			address_versions.push @polling_location.address + ', ' + \
			                      @polling_location.precincts.first.street_segments.first.start_street_address.city + ', ' +
			                      @polling_location.precincts.first.locality.state.name 
		end	
		@polling_loc_std = nil

		address_versions.each do |addr|
			if @polling_loc_std.nil? then
				begin
					@polling_loc_std = gg.locate addr
				rescue
					@polling_loc_std = nil
				end
			end #polling_loc_std.nil
		end #each address

		if (!@polling_loc_std.nil?) then
			
			pollurl = 'http://www.martintod.org.uk/blog/LDballotBox.png'
			@map = GMap.new('map_div')
			@map.icon_global_init(GIcon.new(
				:copy_base => GIcon::DEFAULT,
				:image => pollurl,
				:icon_size => GSize.new(20,34)),
#				:icon_anchor => GPoint.new(7,7),
#				:info_window_anchor => GPoint.new(9,2)),
				"icon_poll")
			icon_poll = Variable.new("icon_poll")
			@map.control_init(:large_map => true, :map_type => true)
			@map.center_zoom_init(@polling_loc_std.coordinates,15)
			@map.overlay_init(GMarker.new(@polling_loc_std.coordinates,
			                    :title => @polling_location.name,
			                    :info_window => @polling_location.name, 
			                    :icon => icon_poll
				    ))
		end
		add_crumb "Source", @polling_location.source
		add_crumb "State", @polling_location.precincts.first.locality.state
		add_crumb "Locality", @polling_location.precincts.first.locality
		#TODO: add precinct crumb if possible
		add_crumb "Polling Location"
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@polling_locations = @source.polling_locations
			add_crumb "Source", @source
			add_crumb "Polling Locations"
		elsif (params["locality"])
			@locality = Locality.find(params["locality"])
			@polling_locations = @locality.precincts.map(&:polling_locations)
			add_crumb "Source", @locality.source
			add_crumb "State", @locality.state
			add_crumb "Locality", @locality
			add_crumb "Polling Locations"
		elsif (params["precinct"])
			@precinct = Locality.find(params["precinct"])
			@polling_locations = @precinct.polling_locations
			add_crumb "Source", @precinct.source
			add_crumb "State", @precinct.locality.state
			add_crumb "Locality", @precinct.locality
			add_crumb "Precinct", @precinct
			add_crumb "Polling Locations"
		else
			@polling_locations = PollingLocation.find(:all)
			add_crumb "Polling Locations"
		end
	end
end
