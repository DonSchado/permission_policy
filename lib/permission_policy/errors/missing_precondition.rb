module PermissionPolicy
  class MissingPrecondition < StandardError
    attr_reader :precondition

    def initialize(precondition)
      @precondition = precondition
    end

    def message
      "missing precondition: #{precondition}"
    end
  end
end
