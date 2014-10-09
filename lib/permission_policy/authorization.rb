module PermissionPolicy
  class Authorization
    attr_reader :preconditions

    def initialize(context)
      @preconditions = []

      PermissionPolicy.config.preconditions.each do |precondition|
        set! precondition, context.public_send(precondition)
        @preconditions << precondition
      end
    end

    private

    def set!(var, value)
      self.class.send(:attr_reader, var)
      instance_variable_set(:"@#{var}", value) or raise PermissionPolicy::MissingPrecondition.new(var)
    end
  end
end
