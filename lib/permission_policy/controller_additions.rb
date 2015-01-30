require 'active_support/concern'

module PermissionPolicy
  module ControllerAdditions
    module ClassMethods
      def authorize_with(*args)
        PermissionPolicy.authorize_with(*args)
      end

      def verify_authorization!(setting = true)
        PermissionPolicy.verify_authorization!(setting)
      end
    end

    module InstanceMethods
      extend ActiveSupport::Concern

      included do
        helper_method :allowed?
        delegate :allowed?, to: :permission_policy
        delegate :authorize!, to: :permission_policy
        after_action -> { verify_authorization if PermissionPolicy.verification }
      end

      def permission_policy
        @permission_policy ||= PermissionPolicy::Authorization.new(self)
      end

      def verify_authorization
        raise PermissionPolicy::NotVerified unless @permission_policy.verified
      end
    end
  end
end
