# frozen_string_literal: true

class ScrapCbfRecord
  # Base error for all ScrapCbf errors.
  class BaseError < ::StandardError; end

  # Raise when error occurs while decoding
  class JsonDecodeError < BaseError
    def initialize(argument)
      super(argument)
    end
  end

  # Raise when missing a Hash key
  class MissingKeyError < BaseError
    def initialize(arg)
      message = "Hash missing required key: #{arg}"
      super(message)
    end
  end

  # Raise when a validation error is found
  class ActiveRecordValidationError < BaseError
    def initialize
      message = 'An error raised while saving records.' \
      ' Check the log for more details'
      super(message)
    end
  end
end
