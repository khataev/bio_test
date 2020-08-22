# frozen_string_literal: true

module Resource
  module Project
    class Create < Trailblazer::Operation
      step Model(::Project, :new)
      step Contract::Build(constant: Resource::Project::Contracts::Create)
      step Contract::Validate()
      step Contract::Persist()
    end
  end
end
