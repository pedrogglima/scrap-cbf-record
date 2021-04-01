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

  # Raise when the championship instance is not found on database
  class ChampionshipInstanceNotFoundError < BaseError
    def initialize(year)
      message = "The Championship instance for year #{year}" \
      ' was not found on database. Check if the values are right' \
      ' or the instance exist on database, before saving records'

      super(message)
    end
  end

  class RecordClassNotDefinedError < BaseError
    def initialize(record)
      message = "The record class #{record.class_name}" \
      ' was not defined. Check if the class exist or is being loaded'

      super(message)
    end
  end

  class RecordAssociationAttributeNotDefinedError < BaseError
    def initialize(record, attribute)
      message = "The record class #{record.class_name}" \
      " has not defined the attribute #{attribute}." \
      " If you don't want define this attribute," \
      ' remove it from the config associations.'

      super(message)
    end
  end

  class RecordAttributeNotDefinedError < BaseError
    def initialize(record, attribute)
      message = "The record class #{record.class}" \
      " has not defined the attribute #{attribute}." \
      " If you don't want define this attribute," \
      ' add it to the config lists of excludes on create and update.'

      super(message)
    end
  end

  class RecordRenameAttributeNotDefinedError < BaseError
    def initialize(record, attribute)
      message = "The record class #{record.class}" \
      " has not defined the renamed attribute #{attribute}." \
      ' Check if you write the attribute name correct, or' \
      ' if you don\'t want rename, remove it from the config list rename attrs.'

      super(message)
    end
  end
end
