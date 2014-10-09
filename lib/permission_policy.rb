require 'ostruct'
require 'permission_policy/version'
require 'permission_policy/railtie' if defined?(Rails)

module PermissionPolicy
  class Configuration < OpenStruct
    def preconditions
      precondition_attributes
    end

    def strategies
      strategies
    end
  end

  autoload :Authorization, 'permission_policy/authorization'
  autoload :MissingPrecondition, 'permission_policy/errors/missing_precondition'
  autoload :NotAllowed, 'permission_policy/errors/not_allowed'

  module Strategies
    autoload :BaseStrategy, 'permission_policy/strategies/base_strategy'
  end

  class << self
    attr_accessor :configuration

    def configure
      yield(config)
    end

    def config
      self.configuration ||= Configuration.new(precondition_attributes: [:current_user], strategies: [])
    end
  end
end
