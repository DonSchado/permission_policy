require 'ostruct'
require 'permission_policy/version'
require 'permission_policy/railtie' if defined?(Rails)

module PermissionPolicy
  class Configuration < OpenStruct
    def preconditions
      precondition_attributes.compact
    end
  end

  autoload :Authorization, 'permission_policy/authorization'
  autoload :MissingPrecondition, 'permission_policy/errors/missing_precondition'

  class << self
    attr_accessor :configuration

    def configure
      yield(config)
    end

    def config
      self.configuration ||= Configuration.new(precondition_attributes: [:current_user])
    end
  end
end
