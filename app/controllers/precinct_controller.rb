class PrecinctController < ApplicationController
	require 'rubygems'
	require 'google_geocode'
	def show
		@precinct = Precinct.find(params[:id])
		@polling_location = @precinct.polling_location
		if @polling_location.nil? then
			render :action => "show"
		else
			render :action => "show_poll"
		end
	end
	def lookupa
		if request.post?
			ss = StreetSegment.new.find_by_address(params[:form_data])
			@precinct = ss.precinct
			redirect_to :action => 'show', :id => @precinct.id
		end
	end
	def lookup
		if request.post?
			data = params[:form_data]
			input_address = data[:street_num] + " " +
			                data[:street] + ", " +
			                data[:city] + ", " +
			                data[:state]
			#standardize address
			gg = GoogleGeocode.new "ABQIAAAAu7Re6QJVDQ3U5Sp2u2w3UhSwMyR9mQOTO__cwzDlnGLWnDHQaxQofqAx35lKdPCM1ODtbttHZKOR3Q"	
			@loc = gg.locate input_address
			homeaddress = @loc.address
			
			#still just a string, but at least it looks good 
			
			@precinct = StreetSegment.new.find_by_address(data).precinct
			@polling_location = @precinct.polling_location
			
			address_versions = []
			address_versions.push @polling_location.name + ', '+@polling_location.address+', '+data[:city]+', '+data[:state] 
			address_versions.push @polling_location.name + ', '+@polling_location.address+', '+data[:state]
			address_versions.push @polling_location.address+', '+data[:city]+', '+data[:state] 
			address_versions.push @polling_location.address+', '+data[:state]
			address_versions.push @polling_location.address

			@polling_loc_std = nil

			address_versions.each do |addr|
				if @polling_loc_std.nil? then
					begin
						puts addr
						@polling_loc_std = gg.locate addr
					rescue
						@polling_loc_std = nil
					end
				end
			end

			@map = GMap.new('map_div')
			if (!@polling_loc_std.nil?) then
				#find bounding box to include polling 
				#and home addresses
				sw = GLatLng.new([[@polling_loc_std.latitude, @loc.latitude].max,[@polling_loc_std.longitude, @loc.longitude].min])
				ne = GLatLng.new([[@polling_loc_std.latitude, @loc.latitude].min,[@polling_loc_std.longitude, @loc.longitude].max])
				@map.center_zoom_on_bounds_init(GLatLngBounds.new(sw,ne))
				
				pollurl = 'http://www.martintod.org.uk/blog/LDballotBox.png'
				homeurl = 'http://maps.google.com/mapfiles/kml/shapes/homegardenbusiness.png'
				@map.icon_global_init(GIcon.new(
					:copy_base => GIcon::DEFAULT,
					:image => pollurl,
					:icon_size => GSize.new(20,34)),
#					:icon_anchor => GPoint.new(7,7),
#					:info_window_anchor => GPoint.new(9,2)),
					"icon_poll")
				@map.icon_global_init(GIcon.new(
					:copy_base => GIcon::DEFAULT,
					:image => homeurl,
					:icon_size => GSize.new(20,34)),
#					:icon_anchor => GPoint.new(7,7),
#					:info_window_anchor => GPoint.new(9,2)),
					"icon_home")
				icon_poll = Variable.new("icon_poll")
				icon_home = Variable.new("icon_home")
				@map.overlay_init(GMarker.new(@polling_loc_std.coordinates,
				                    :title => @polling_location.name,
				                    :info_window => @polling_location.name, 
				                    :icon => icon_poll
						    ))

			end
			@map.overlay_init(GMarker.new(@loc.coordinates,
			                    :title => @loc.address,
			                    :info_window => homeaddress,
					    :icon_size => GSize.new(25,25),
			                    :icon => icon_home))
			@map.control_init(:large_map => true, :map_type => true)
#			@map.center_zoom_init([@loc.latitude, @loc.longitude],15)


		end
	end
end