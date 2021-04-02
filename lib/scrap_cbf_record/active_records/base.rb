# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    # Superclass for the classes lib/active_records/<record>.rb
    class Base
      def initialize(current_config, config)
        # classes set by users
        # e.g @class_championship => # may be Cup class
        #
        @class_championship = config.championship.klass
        @class_match = config.match.klass
        @class_ranking = config.ranking.klass
        @class_round = config.round.klass
        @class_team = config.team.klass

        # current config is associated with the current record class
        #
        @current_config = current_config
        # configs associated with the record classes
        #
        @config_match = config.match
        @config_ranking = config.ranking
        @config_round = config.round
        @config_team = config.team

        # current configs set by users
        #
        @associations = @current_config.associations
        @exclude_attrs_on_create = @current_config.exclude_attrs_on_create
        @exclude_attrs_on_update = @current_config.exclude_attrs_on_update
        @rename_attrs = @current_config.rename_attrs

        # current configs required by the system
        #
        @must_exclude_attrs = @current_config.must_exclude_attrs
      end

      # Normalize, on create, the new record with:
      # Setting Associations
      # Rename attributes
      # Exclusion of attributes
      #
      # @param [Hash] contaning the new record
      # @param [Hash] contaning the existent record's associations
      # @return [Hash] normalized
      def normalize_before_create(hash, assocs = {})
        hash = include_associations(
          hash,
          @associations,
          assocs
        )

        hash = exclude_attrs(
          hash,
          @exclude_attrs_on_create,
          @must_exclude_attrs,
          @associations.keys
        )

        hash = rename_attrs(hash, @rename_attrs)

        hash
      end

      # Normalize, on update, the new record with:
      # Setting Associations
      # Rename attributes
      # Exclusion of attributes
      #
      # @param [Hash] contaning the new record
      # @param [Hash] contaning the existent record's associations
      # @return [Hash] normalized
      def normalize_before_update(hash, assocs = {})
        hash = include_associations(
          hash,
          @associations,
          assocs
        )

        hash = exclude_attrs(
          hash,
          @exclude_attrs_on_update,
          @must_exclude_attrs,
          @associations.keys
        )

        hash = rename_attrs(hash, @rename_attrs)

        hash
      end

      # Save record instance or log the errors found
      #
      # @raise [ActiveRecordValidationError]
      # @param record [ActiveRecord] instance to be saved
      # @return [ActiveRecord] the instance saved
      def save_or_log_error(record)
        if record.valid?
          record.save
        else
          log_record_errors(record)
          raise ActiveRecordValidationError
        end
        record
      end

      protected

      def include_associations(hash, associations, assocs)
        associations.each do |name, attrs|
          instance = assocs[name.to_sym]

          foreign_key = attrs[:foreign_key]

          # for cases where instance is:
          # - association is empty (nil)
          # - association is present
          #
          # update hash with the foreign_key
          hash[foreign_key.to_sym] = (instance.id if instance.present?)
        end

        hash
      end

      def exclude_attrs(hash, attrs, must_exclude, associations)
        exclude = attrs + associations + must_exclude
        hash.except(*exclude)
      end

      def rename_attrs(hash, renames)
        # rename attrs
        renames.each do |key, val|
          hash[val.to_sym] = hash.delete(key) if hash.key?(key)
        end

        hash
      end

      def raise_unless_respond_to_each(records, records_type)
        return if records.respond_to?(:each)

        raise ::ArgumentError, "#{records_type} must respond to method :each"
      end

      def log_record_errors(record)
        TagLogger.with_context(record.class, 'Errors found while saving')
        record.errors.each do |attribute, message|
          TagLogger.with_context('error', "#{attribute}: #{message}")
        end
      end
    end
  end
end
