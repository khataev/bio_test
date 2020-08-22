# require 'reform/form/dry'
#
# Reform::Form.class_eval do
#   include Reform::Form::Dry
# end

require 'reform/form/active_model/validations'

Reform::Form.class_eval do
  include Reform::Form::ActiveModel::Validations
end