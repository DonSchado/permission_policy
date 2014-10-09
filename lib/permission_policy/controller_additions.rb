module PermissionPolicy
  module ControllerAdditions
    helper_method :allowed?

    delegate :allowed?, to: :permission_policy
    delegate :authorize!, to: :permission_policy

    def permission_policy
      @permission_policy ||= PermissionPolicy::Authorization.new(self)
    end
  end
end
