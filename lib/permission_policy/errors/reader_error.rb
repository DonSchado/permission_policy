module PermissionPolicy
  class ReaderError < StandardError
    attr_reader :definition

    def initialize(definition)
      @definition = definition
    end

    def message
      "#{definition} not defined"
    end
  end
end
