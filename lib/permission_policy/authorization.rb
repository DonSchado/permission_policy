module PermissionPolicy
  class Authorization
    def initialize(context)
      PermissionPolicy.config.preconditions.each do |precondition|
        set! precondition, context.public_send(precondition)
      end
    end

    private

    def set!(var, value)
      self.class.send(:attr_reader, var)
      instance_variable_set(:"@#{var}", value) or raise PermissionPolicy::MissingPrecondition.new(var)
    end
  end
end
