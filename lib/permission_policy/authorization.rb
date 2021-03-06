module PermissionPolicy
  class Authorization
    attr_reader :preconditions, :verified, :context

    def initialize(context)
      @preconditions = []
      @context = context

      context.authorization_preconditions.each do |precondition|
        set! precondition, context.public_send(precondition)
        @preconditions << precondition
      end
    end

    # Decides if the action is allowed based on the matching strategy.
    # You may want to use this method for controlflow inside views.
    #
    # Example:
    #
    #  do_something if allowed?(:manage, subject: my_subject)
    #
    def allowed?(action, options = {})
      strategy_for(action, options).allowed?
    end

    # Delegates to #allowed? but raises a NotAllowed exception when false.
    # You may want to use this method for halting the execution of a controller method.
    #
    # Example:
    #
    #   def edit
    #     allow!(:manage, subject: my_subject)
    #   end
    #
    def authorize!(action, options = {})
      @verified = true
      !!allowed?(action, options) or raise PermissionPolicy::NotAllowed
    end

    private

    # Finds the matching strategy which can decide if the action is allowed by lazy checking
    def strategy_for(*args)
      @context.authorization_strategies.lazy.map do |klass|
        Strategies.const_get(klass).new(self, *args)
      end.find(&:match?)
    end

    def set!(var, value)
      self.class.send(:attr_reader, var)
      instance_variable_set(:"@#{var}", value) or raise PermissionPolicy::MissingPrecondition.new(var)
    end
  end
end
