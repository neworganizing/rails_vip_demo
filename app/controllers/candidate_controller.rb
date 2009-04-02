class CandidateController < ApplicationController
	
	def show
		@candidate = Candidate.find(params[:id])
		add_crumb "Source", @candidate.source
		#TODO: add crumb for candidate
		add_crumb "Candidate"
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@candidates = @source.candidates
			add_crumb "Source", @source
			add_crumb "Candidates"
		else
			@candidates = Candidate.find(:all)
			add_crumb "Candidates"
		end
	end
end
