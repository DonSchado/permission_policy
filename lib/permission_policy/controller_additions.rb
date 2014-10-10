require 'active_support/concern'

module PermissionPolicy
  module ControllerAdditions
    module ClassMethods
      def authorize_with(*args)
        PermissionPolicy.authorize_with(*args)
      end
    end

    module InstanceMethods
      extend ActiveSupport::Concern

      included do
        helper_method :allowed?
        delegate :allowed?, to: :permission_policy
        delegate :authorize!, to: :permission_policy
      end

      def permission_policy
        @permission_policy ||= PermissionPolicy::Authorization.new(self)
      end
    end
  end
end
