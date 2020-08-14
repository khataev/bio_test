# frozen_string_literal: true

module Client::Operations
  class Create < Trailblazer::Operation
    # rubocop:disable Lint/UnreachableCode
    pass :setup_projects_params
    step :create_client
    fail :prepare_client_errors

    pass :create_projects
    step :prepare_result, pass_fast: true
    # rubocop:enable Lint/UnreachableCode

    def setup_projects_params(ctx, params:, **)
      ctx[:projects_params] = params.delete(:projects) || []
    end

    def create_client(ctx, params:, **)
      ctx[:client] = Client.create(params)
      ctx[:client].valid?
    end

    # HINT: обработка ошибок возможна, но, дабы не усложнять, пока без нее
    def create_projects(_ctx, client:, projects_params:, **)
      projects_params.each do |project_params|
        client.projects.create(project_params)
      end
    end

    def prepare_result(ctx, client:, **)
      ctx[:result] = client
    end

    def prepare_client_errors(ctx, client:, **)
      ctx[:result] = client.errors.full_messages
    end
  end
end
