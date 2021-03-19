# frozen_string_literal: true

class ScrapCbfRecord
  # Base error for all ScrapCbf errors.
  class BaseError < ::StandardError; end

  class JsonDecodeError < BaseError
    def initialize(argument)
      super(argument)
    end
  end

  class MissingKeyError < BaseError
    def initialize(arg)
      message = "Hash missing required key: #{arg}"
      super(message)
    end
  end
end
