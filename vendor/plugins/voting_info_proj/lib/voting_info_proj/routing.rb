module VotingInfoProj #:nodoc:
  module Routing #:nodoc:
    module MapperExtensions
      def voting_info_proj
        @set.add_route("/precinct", {:controller => "precinct", :action => "index"})
        @set.add_route("/precinct/:action", {:controller => "precinct"})
        @set.add_route("/precinct/:action/:id", {:controller => "precinct"})
        @set.add_route("/locality", {:controller => "locality", :action => "index"})
        @set.add_route("/locality/:action", {:controller => "locality"})
        @set.add_route("/locality/:action/:id", {:controller => "locality"})
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, VotingInfoProj::Routing::MapperExtensions