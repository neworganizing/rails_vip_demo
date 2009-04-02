class SourceController < ApplicationController
	def index
		@sources = Source.find(:all, :conditions => "active = 1")
		@sources.sort! {|a,b| a.name <=> b.name}
		add_crumb "Sources"
	end
	def show 
		@source = Source.find(params[:id])
		add_crumb "Source"
	end
end
