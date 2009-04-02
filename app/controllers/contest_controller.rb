class ContestController < ApplicationController

	def show
		@contest = Contest.find(params[:id])
		if @contest and @contest.ballot
			@referendum = @contest.ballot.referendum 
			@responses = []
			if @referendum and @referendum.ballot_responses.count > 0
				@responses = @referendum.ballot_responses.collect &:text
			end
			@candidates = @contest.ballot.candidates.size > 0 ? @contest.ballot.candidates : nil
			add_crumb "Source", @contest.source
			add_crumb "Election", @contest.election
			add_crumb "Contest"
		end
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@contests = @source.contests
			add_crumb "Source", @source
			add_crumb "Contests"
		else
			@contests = Contest.find(:all)
			add_crumb "Contests"
		end
	end
end
