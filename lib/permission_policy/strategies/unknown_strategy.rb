module PermissionPolicy
  module Strategies
    # Fallback strategy if no other matches. It allways matches and always
    # denies access no matter what.
    class UnknownStrategy < BaseStrategy
      def match?
        true
      end

      def allowed?
        false
      end
    end
  end
end
