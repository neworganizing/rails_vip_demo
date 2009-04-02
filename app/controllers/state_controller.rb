class StateController < ApplicationController

	def show
		@state = State.find(params[:id])
		add_crumb "Source", @state.source
		add_crumb "State"
	end

	def index
		if (params["source"])
			source = Source.find(params["source"])
			@states = source.states
			add_crumb "Source", @state.source
			add_crumb "State"
		else
			@states = State.find(:all)
		end
	end
end
