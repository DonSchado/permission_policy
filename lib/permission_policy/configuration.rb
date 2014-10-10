module PermissionPolicy
  class Configuration < OpenStruct
    def preconditions
      precondition_attributes || [:current_user]
    end

    def strategies
      strategy_order || [:UnknownStrategy]
    end
  end

  class << self
    attr_accessor :configuration

    extend Forwardable
    delegate [:preconditions, :strategies] => :config

    def configure
      yield(config)
    end

    def config
      self.configuration ||= Configuration.new
    end

    def authorize_with(*args)
      configure { |c| c.precondition_attributes = *args }
    end
  end
end
