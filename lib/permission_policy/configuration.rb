module PermissionPolicy
  class Configuration < OpenStruct
    def preconditions
      precondition_attributes || [:current_user]
    end

    def strategies
      strategy_order || [:UnknownStrategy]
    end

    def log(message)
      logging.debug(message) && !!debug_logger
    end

    def logging
      logger || Logger.new(STDOUT)
    end
  end

  class << self
    attr_accessor :configuration

    extend Forwardable
    delegate [:preconditions, :strategies, :log] => :config

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
