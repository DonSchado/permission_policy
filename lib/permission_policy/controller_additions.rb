require 'active_support/concern'

module PermissionPolicy
  module ControllerAdditions
    module ClassMethods
      def authorize_with(*preconditions)
        define_method('authorization_preconditions') { preconditions }
      end

      def verify_authorization!
        define_method('authorization_verification?') { true }
      end

      def skip_verify_authorization
        define_method('authorization_verification?') { false }
      end

      def authorization_strategies(*strategies)
        define_method('authorization_strategies') { strategies }
      end
    end

    module InstanceMethods
      extend ActiveSupport::Concern

      included do
        helper_method :allowed?
        delegate :allowed?, to: :permission_policy
        delegate :authorize!, to: :permission_policy
        after_action -> { verify_authorization if authorization_verification? }
      end

      def permission_policy
        @permission_policy ||= PermissionPolicy::Authorization.new(self)
      end

      def verify_authorization
        raise PermissionPolicy::NotVerified unless permission_policy.verified
      end
    end
  end
end
