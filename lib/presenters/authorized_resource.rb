# frozen_string_literal: true

module Presenters
  class AuthorizedResource < SimpleDelegator
    def initialize(obj, embedded_property_name = nil, embedded_property_value = nil)
      define_embedded_property(embedded_property_name, embedded_property_value)

      super obj
    end

    private

    def define_embedded_property(name, value)
      return unless name

      self.class.define_method(name) { value }
    end
  end
end