# frozen_string_literal: true

require 'singleton'

require_relative 'configs/base'
require_relative 'configs/championship'
require_relative 'configs/match'
require_relative 'configs/ranking'
require_relative 'configs/round'
require_relative 'configs/team'

class ScrapCbfRecord
  # This class is responsible for holding the configs on how records
  # must be save on database. That means:
  # - which class to use to save the records
  # - which record attributes to exclude on create and update
  # - which record attributes to rename
  # Each of the configs are set for each record:
  # - match record
  # - ranking record
  # - round record
  # - team record
  class Config
    include Singleton

    def championship
      @championship ||= Championship.new
    end

    def match
      @match ||= Match.new
    end

    def ranking
      @ranking ||= Ranking.new
    end

    def round
      @round ||= Round.new
    end

    def team
      @team ||= Team.new
    end

    # Return an array with all record classes
    #
    # @return [Array]
    def record_classes
      [
        @championship.constant,
        @match.constant,
        @ranking.constant,
        @round.constant,
        @team.constant
      ]
    end

    # Return an array with all config classes
    #
    # @return [Array]
    def config_classes
      [
        @championship,
        @match,
        @ranking,
        @round,
        @team
      ]
    end

    # Restaure configs to default
    #
    # @return [Boolean] true if works
    def restore
      @championship = Championship.new
      @match = Match.new
      @ranking = Ranking.new
      @round = Round.new
      @team = Team.new

      true
    end

    private_class_method :new

    def validate!
      config_classes.each do |config_record|
        validate_record_presence!(config_record)

        validate_attrs_presence!(config_record)

        validate_associations_presence!(config_record)
      end

      true
    end

    # Validate if Record is defined
    #
    # @raise [RecordClassNotDefinedError] if record is not defined
    # @return [Objct] true if works
    def validate_record_presence!(config_record)
      config_record.constant
    rescue NameError
      raise RecordClassNotDefinedError, config_record
    end

    # Validate if association attribute exist on Record class
    #
    # @raise [RecordAssociationAttributeNotDefinedError] if not found
    # @return [Array] returns array of associations
    def validate_associations_presence!(config_record)
      record_instance = config_record.constant.new

      # validte foreign key associations
      config_record.associations.each do |_key, assoc|
        begin
          record_instance.send assoc[:foreign_key] if assoc.key?(:foreign_key)
        rescue NameError
          raise(
            RecordAssociationAttributeNotDefinedError.new(
              config_record,
              assoc[:foreign_key]
            )
          )
        end
      end
    end

    # Validate the presence on the record class
    #  for the attributes renamed and non-exclude.
    #
    # @raise [RecordRenameAttributeNotDefinedError] if renamed not found
    # @raise [RecordAttributeNotDefinedError] if non-exclude not found
    # @return [Boolean] returns true if valid
    def validate_attrs_presence!(config_record)
      record_instance = config_record.constant.new
      exclude_attrs = config_record.exclude_attrs
      rename_attrs = config_record.rename_attrs

      config_record.record_attrs.each do |attribute|
        # if is a renamed attr, its original form is exclude
        # so we only have to check it here
        if rename_attrs.key?(attribute)
          validate_attr_presence_from_rename!(
            record_instance,
            attribute,
            rename_attrs
          )
        else
          # non-exclude are the ones: not renamed, associated or excluded
          validate_attr_presence_from_exclude!(
            record_instance,
            attribute,
            exclude_attrs
          )
        end
      end

      true
    end

    # Validate if renamed attribute exist on Record class
    #
    # @raise [RecordRenameAttributeNotDefinedError] if not found
    # @return [Object] returns the attribute found
    def validate_attr_presence_from_rename!(
      record_instance,
      attribute,
      rename_attrs
    )
      if rename_attrs.key?(attribute)
        record_instance.send rename_attrs[attribute]
      end
    rescue NameError
      raise(
        ScrapCbfRecord::RecordRenameAttributeNotDefinedError.new(
          record_instance,
          rename_attrs[attribute]
        )
      )
    end

    # Validate if non-exclude attribute exist on Record class
    #
    # @raise [RecordAttributeNotDefinedError] if not found
    # @return [Object] returns the attribute found
    def validate_attr_presence_from_exclude!(
      record_instance,
      attribute,
      exclude_attrs
    )
      record_instance.send attribute unless exclude_attrs.include?(attribute)
    rescue NameError
      raise(
        ScrapCbfRecord::RecordAttributeNotDefinedError.new(
          record_instance,
          attribute
        )
      )
    end
  end
end
