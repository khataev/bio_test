# frozen_string_literal: true

module Resource
  module Client
    module Contracts
      class Create < Resource::Client::Contracts::Form
        collection :projects,
                   form: Resource::Project::Contracts::Form,
                   populate_if_empty: ::Project
      end
    end
  end
end