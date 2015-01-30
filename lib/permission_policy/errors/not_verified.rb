module PermissionPolicy
  class NotVerified < StandardError
    def message
      'authorization not verified'
    end
  end
end
