# frozen_string_literal: true

class ScrapCbfRecord
  class Config
    # Superclass for the classes lib/config/<record>.rb
    class Base
      class << self
        # Users may configure these settings
        #
        # @return [Hash] holding users or default settings
        def default
          raise NotImplementedError, 'default method must be implemented'
        end

        # These settings are not configurable by user
        #
        # @return [Hash] holding system settings
        def required
          raise NotImplementedError, 'required method must be implemented'
        end

        # Returns the key :class_name from the method default
        # Class_name is used to find a specific record class
        # The user may set a custom name for the specific record class
        #
        # @return [String, Symbol] holding class name
        def default_class_name
          default[:class_name]
        end

        # Returns the key :rename_attrs from the method default
        #
        # @return [Hash] with key been attrs name and value the renamed
        def default_rename_attrs
          default[:rename_attrs]
        end

        # Returns the key :exclude_attrs_on_create from the method default
        #
        # @return [Array] holding attrs to be exclude on create
        def default_exclude_attrs_on_create
          default[:exclude_attrs_on_create]
        end

        # Returns the key :exclude_attrs_on_update from the method default
        # Rename_attrs is a array of strings contaning the attrs to be renamed
        #
        # @return [Array] holding attrs to be exclude on update
        def default_exclude_attrs_on_update
          default[:exclude_attrs_on_update]
        end

        # Returns the key :associations from the method default
        # The associations are name of associations that a record has
        #
        # @return [Array] holding existent associations for the record
        def default_associations
          default[:associations]
        end

        # Returns the key :must_not_rename_attrs from the method required
        #
        # @return [Array] holding attrs that must not be renamed
        def must_not_rename_attrs
          required[:must_not_rename_attrs]
        end

        # Returns the key :must_exclude_attrs from the method required
        #
        # @return [Array] holding attrs that must be excluded
        def must_exclude_attrs
          required[:must_exclude_attrs]
        end

        # Returns the key :must_keep_attrs from the method required
        #
        # @return [Array] holding attrs that must not be excluded
        def must_keep_attrs
          required[:must_keep_attrs]
        end
      end

      # @param [class_name] default[:class_name]
      # @param [rename_attrs] default[:rename_attrs]
      # @param [exclude_attrs_on_create] default[:exclude_attrs_on_create]
      # @param [exclude_attrs_on_update] default[:exclude_attrs_on_update]
      # @param [associations] default[:associations]
      # @return [nil]
      def initialize(
        class_name,
        rename_attrs,
        exclude_attrs_on_create,
        exclude_attrs_on_update,
        associations
      )
        @class_name = class_name
        @rename_attrs = rename_attrs
        @exclude_attrs_on_create = exclude_attrs_on_create
        @exclude_attrs_on_update = exclude_attrs_on_update
        @associations = associations
      end

      # These method receives the users settings
      #
      # @param [class_name]
      # @param [rename_attrs]
      # @param [exclude_attrs_on_create]
      # @param [exclude_attrs_on_update]
      # @param [associations]
      # @return [nil]
      def config=(
        class_name,
        rename_attrs,
        exclude_attrs_on_create,
        exclude_attrs_on_update,
        associations
      )
        @class_name = class_name
        @rename_attrs = rename_attrs
        @exclude_attrs_on_create = exclude_attrs_on_create
        @exclude_attrs_on_update = exclude_attrs_on_update
        @associations = associations
      end

      # Returns the class defined on class_name instance variable
      # Class_name is a string or symbol and is set by user or default
      #
      # @raise [NameError] with class is not found
      # @return [Object] class set by user
      def constant
        Object.const_get(@class_name)
      end

      # Check if argument matches with the subclasses name.
      # This helps check if config correspond to the right active record config
      #
      # @param [self_record] symbol/string to be match with self subclasse name
      # @return [Boolean]
      def self_assoc?(self_record)
        config_name = self.class.name.split('::').last

        config_name.downcase == self_record.to_s
      end

      # Check if current config has specific setting association.
      #
      # @return [Boolean]
      def championship_assoc?
        return false unless @associations

        @championship_assoc ||= @associations.include?(:championship)
      end

      # Check if current config has specific setting association.
      #
      # @return [Boolean]
      def round_assoc?
        return false unless @associations

        @round_assoc ||= @associations.include?(:round)
      end

      # Check if current config has specific setting association.
      #
      # @return [Boolean]
      def team_assoc?
        return false unless @associations

        @team_assoc ||= @associations.include?(:team)
      end

      # Check if current config has any association.
      #
      # @return [Boolean]
      def association?
        !@associations.empty?
      end

      # Returns required must_not_rename_attrs
      #
      # @return [Array]
      def must_not_rename_attrs
        self.class.must_not_rename_attrs
      end

      # Returns required must_exclude_attrs
      #
      # @return [Array]
      def must_exclude_attrs
        self.class.must_exclude_attrs
      end

      # Returns required must_keep_attrs
      #
      # @return [Array]
      def must_keep_attrs
        self.class.must_keep_attrs
      end

      def class_name_validation(class_name)
        unless string?(class_name)
          raise ::ArgumentError,
                'Invalid type: class name must be a string or a symbol'
        end

        begin
          Object.const_get(class_name)
        rescue ::NameError
          raise_custom_name_error(class_name)
        end
      end

      private

      def raise_custom_name_error(class_name)
        raise ::NameError, "uninitialized constant #{class_name}. " \
          'the classes needed by this gem need to be declared (see doc).'
      end

      def string?(var)
        !var.nil? && (var.is_a?(String) || var.is_a?(Symbol))
      end

      def default_class_name
        self.class.default_class_name
      end

      def default_rename_attrs
        self.class.default_rename_attrs
      end

      def default_exclude_attrs_on_create
        self.class.default_exclude_attrs_on_create
      end

      def default_exclude_attrs_on_update
        self.class.default_exclude_attrs_on_update
      end

      def default_associations
        self.class.default_associations
      end
    end
  end
end
