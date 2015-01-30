module PermissionPolicy
  class Configuration < OpenStruct
    def preconditions
      precondition_attributes || [:current_user]
    end

    def strategies
      strategy_order || [:UnknownStrategy]
    end

    def verification
      verify_authorization || false
    end
  end

  class << self
    attr_accessor :configuration

    extend Forwardable
    delegate [:preconditions, :strategies, :verification] => :config

    def configure
      yield(config)
    end

    def config
      self.configuration ||= Configuration.new
    end

    def authorize_with(*args)
      configure { |c| c.precondition_attributes = *args }
    end

    def verify_authorization!(setting)
      configure { |c| c.verify_authorization = setting }
    end
  end
end
