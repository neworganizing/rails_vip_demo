class PrecinctSplitsController < ApplicationController
  # GET /precinct_splits
  # GET /precinct_splits.xml
  def index
    @precinct_splits = PrecinctSplit.find(:all)
    add_crumb "Source"

  end

  # GET /precinct_splits/1
  # GET /precinct_splits/1.xml
  def show
    @precinct_split = PrecinctSplit.find(params[:id])

  end

end
