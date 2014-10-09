module PermissionPolicy
  module Strategies
    #
    # The base strategy defines the object API for all strategies which can be
    # used for permission checks. Each strategy should inherit from it and
    # implement #match? and #allowed?
    #
    class BaseStrategy
      # attributes which are available for #match? and #allowed?
      # are passed from the authorization class.
      #
      # precondition_attributes:: for example [:current_user]
      # action:: This will be :view or :manage
      # options:: A hash having :subject or :feature as keys
      attr_accessor :action, :options

      def initialize(authorization, action=nil, options={})
        authorization.preconditions.each do |attribute|
          self.class.send(:attr_accessor, attribute)
          instance_variable_set(:"@#{attribute}", authorization.public_send(attribute))
        end

        self.action = action
        self.options = options
      end

      # Check if the strategy is responsible for handling the permission check
      # Has to return true or false
      def match?
        raise NotImplementedError, 'please implement #match? '\
          "for #{self.class.name} which should return true or false, "\
          'depending on if it can decide #allowed?'
      end

      # Check if user has necessary permission
      # Has to return true or false
      def allowed?
        raise NotImplementedError, 'please implement #allowed? '\
          "for #{self.class.name} which should decide if the action is allowed, "\
          'based on the given attributes'
      end
    end
  end
end
