module Clients
  module Http
    class AuthorizeResource
      include HTTParty

      base_uri Settings.hosts.authorize_resource

      # user_id:, resource_name:, action:
      def can?(**params)
        query = { query: params }
        self.class.get('/api/v1/can', query)
      end
    end
  end
end