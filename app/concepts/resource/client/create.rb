# frozen_string_literal: true

module Resource
  module Client
    class Create < Trailblazer::Operation
      step Model(::Client, :new)
      step Contract::Build(constant: Resource::Client::Contracts::Create)
      step Contract::Validate()
      step Contract::Persist()
    end
  end
end
