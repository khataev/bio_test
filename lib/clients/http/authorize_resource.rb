# frozen_string_literal: true

module Clients
  module Http
    class AuthorizeResource
      include HTTParty

      base_uri Settings.hosts.authorize_resource

      # user_id:, action:, resource:
      # action availability example
      # available actions: index, create, (update, show, delete) ?
      # { user_id: 1, action: 'index', resource: 'Project' }
      def check_action(**params)
        request_params = { query: params }
        response = self.class.get('/api/v1/check_action', request_params)
        raise Errors::Unauthorized unless response.success?
      end

      # user_id:, action:, resources: {}
      # available actions: show, update, delete
      # resource access example:
      # { user_id: 1, action: 'show', resource_class: 'Project', resource_ids: [] }
      def check_access(**params)
        request_params = { body: params.to_json, headers: { 'Content-Type': 'application/json' } }
        response = self.class.post('/api/v1/check_access', request_params)
        response.parsed_response
      end
    end
  end
end
