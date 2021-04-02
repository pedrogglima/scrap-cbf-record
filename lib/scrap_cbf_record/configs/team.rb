# frozen_string_literal: true

class ScrapCbfRecord
  class Config
    # Team settings
    class Team < Base
      class << self
        # Default settings
        #
        # @return [Hash]
        def default
          {
            class_name: 'Team',
            rename_attrs: {},
            exclude_attrs_on_create: %i[],
            exclude_attrs_on_update: %i[],
            associations: {}

          }
        end

        # Settings use by the system
        # Not configurable
        #
        # @return [Hash]
        def required
          { must_exclude_attrs: %i[] }
        end

        # Record Attributes
        # It must match with ScrapCbf
        #
        # @return [Array]
        def record_attrs
          %i[
            name
            state
            avatar_url
          ]
        end
      end

      attr_reader :class_name,
                  :rename_attrs,
                  :exclude_attrs_on_create,
                  :exclude_attrs_on_update,
                  :associations

      # Starts the settings with default
      #
      # @return [nil]
      def initialize
        @class_name = default_class_name
        @rename_attrs = default_rename_attrs
        @exclude_attrs_on_create = default_exclude_attrs_on_create
        @exclude_attrs_on_update = default_exclude_attrs_on_update
        @associations = default_associations

        ScrapCbfRecord::Team.config = self

        super(*configs)
      end

      # These method receives the users settings
      # Missing settings are left as default
      #
      # @param [config] Hash contaning the settings
      # @return [nil]
      def config=(config)
        raise ::ArgumentError, 'config must be a Hash' unless config.is_a?(Hash)

        @class_name = config[:class_name] if config[:class_name]
        @rename_attrs = config[:rename_attrs] if config[:rename_attrs]
        if config[:exclude_attrs_on_create]
          @exclude_attrs_on_create = config[:exclude_attrs_on_create]
        end
        if config[:exclude_attrs_on_update]
          @exclude_attrs_on_update = config[:exclude_attrs_on_update]
        end
        @associations = config[:associations] if config[:associations]

        super(*configs)
      end

      # Return the configurable settings
      #
      # @return [Array]
      def configs
        [
          @class_name,
          @rename_attrs,
          @exclude_attrs_on_create,
          @exclude_attrs_on_update,
          @associations
        ]
      end
    end
  end
end
