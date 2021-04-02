# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    # Superclass for the classes lib/active_records/<record>.rb
    class Base
      def initialize(config)
        # config is associated with the current record class
        #
        @config = config

        # This reference the user class used to save on database
        #
        @model = config.klass

        # current configs set by users
        #
        @associations = @config.associations
        @exclude_attrs_on_create = @config.exclude_attrs_on_create
        @exclude_attrs_on_update = @config.exclude_attrs_on_update
        @rename_attrs = @config.rename_attrs

        # current configs required by the system
        #
        @must_exclude_attrs = @config.must_exclude_attrs
      end

      # Normalize, for create and update, the new record with:
      # Setting Associations
      # Rename attributes
      # Exclusion of attributes
      #
      # @param [Object, Nil] the record if exist
      # @param [Hash] contaning the new record
      # @param [Hash] contaning the existent record's associations
      # @return [Object] normalized
      def normalize_before_save(record, hash, associations = {})
        if record
          hash = normalize_before_update(hash, associations)

          record.assign_attributes(hash)

          record
        else
          hash = normalize_before_create(hash, associations)

          @model.new(hash)
        end
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
          # It raises custom error to display message warning about the logs.
          raise ActiveRecordValidationError
        end
        record
      end

      protected

      # Includes associations <attribute_id> and its value to the record hash
      #  only include if the associations was set by the user.
      #
      # @param hash [Hash] record hash to be modified
      # @param associations [Hash] hash contaning associations details
      # @param assocs [Hash] hash contaning the associations
      #  values returned by find_by
      # @return [Hash] record hash with associations included
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

      # Exclude some keys from the record hash
      #
      # @param hash [Hash] record hash to be modified
      # @param attrs [Array] has the keys to be exclude.
      #  These attrs are the union of exclude_attrs_on_create/update.
      # @param must_exclude [Array] has the keys to be excluded.
      #  The keys are set by the lib, and is used to remove unwanted attrs.
      # @param associations [Array] has the names of the associations.
      #  include_associations method does't remove the associations added.
      #  e.g if championship association exist, then:
      #   add championship_id to hash.
      #   But, it doesn't remove the championship key from the hash.
      #   It's remove here.
      # @return [Hash] record hash modified
      def exclude_attrs(hash, attrs, must_exclude, associations)
        exclude = attrs + associations + must_exclude
        hash.except(*exclude)
      end

      # Rename keys from the record hash
      #
      # @param hash [Hash] record hash to be modified
      # @param renames [Hash] has the keys to be renamed by the key's value.
      # @return [Hash] record hash modified
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
        TagLogger.with_context(
          [record.class, Time.current],
          'Errors found while saving'
        )
        record.errors.each do |attribute, message|
          TagLogger.with_context('error', "#{attribute}: #{message}")
        end
      end
    end
  end
end
