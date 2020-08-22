# frozen_string_literal: true

module Resource
  module Project
    class Update < Trailblazer::Operation
      step Contract::Build(constant: Resource::Project::Contracts::Update)
      step Contract::Validate()
      step Contract::Persist()
    end
  end
end
