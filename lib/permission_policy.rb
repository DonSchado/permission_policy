require 'ostruct'
require 'permission_policy/version'
require 'permission_policy/configuration'
require 'permission_policy/railtie' if defined?(Rails)
require 'permission_policy/controller_additions'

module PermissionPolicy
  autoload :Authorization, 'permission_policy/authorization'
  autoload :MissingPrecondition, 'permission_policy/errors/missing_precondition'
  autoload :NotAllowed, 'permission_policy/errors/not_allowed'
  autoload :NotVerified, 'permission_policy/errors/not_verified'

  module Strategies
    autoload :BaseStrategy, 'permission_policy/strategies/base_strategy'
    autoload :UnknownStrategy, 'permission_policy/strategies/unknown_strategy'
  end
end
