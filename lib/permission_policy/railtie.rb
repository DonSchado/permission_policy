module PermissionPolicy
  class Railtie < ::Rails::Railtie
    initializer 'permission_policy.configure_controller' do
      ActiveSupport.on_load :action_controller do
        include PermissionPolicy::ControllerAdditions::InstanceMethods
        extend PermissionPolicy::ControllerAdditions::ClassMethods
      end
    end
  end
end
