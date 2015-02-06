require 'yaml'
require 'active_support/core_ext/hash'

module PermissionPolicy
  class PermissionReader
    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def permissions
      @permissions = to_hash[:permissions]
    end

    def roles
      @roles = to_hash[:roles]
    end

    def to_hash
      @raw ||= read_file.with_indifferent_access
    end

    def features
      permissions.keys
    end

    def permitted?(feature, action, role)
      ensure_definition!(feature, action, role)

      permissions[feature][action] && permissions[feature][action].include?(role)
    end

    private

    def ensure_definition!(feature, action, role)
      raise PermissionPolicy::ReaderError, feature unless features.include? feature
      raise PermissionPolicy::ReaderError, action  unless permissions[feature].keys.include? action
      raise PermissionPolicy::ReaderError, role    unless roles.include? role
    end

    def read_file
      YAML.load_file(file_path)
    end
  end
end
