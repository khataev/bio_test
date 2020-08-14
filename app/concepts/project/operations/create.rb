# frozen_string_literal: true

module Project::Operations
  class Create < Trailblazer::Operation
    pass :setup_client_params, Output(:failure) => Id(:create_project)
    step :create_client
    step :create_project
    step :prepare_result

    def setup_client_params(ctx, params:, **)
      ctx[:client_params] = params.delete(:client)
    end

    # TODO(khataev): errors to result
    def create_client(ctx, params:, client_params:, **)
      client = Client.create(client_params)
      ctx[:params] = params.merge(client_id: client.id)
    end

    def create_project(ctx, params:, **)
      ctx[:project] = Project.create(params)
    end

    def prepare_result(ctx, project:, **)
      ctx[:result] =
        if project.valid?
          project
        else
          project.errors.full_messages
        end

      project.valid?
    end
  end
end