# frozen_string_literal: true

class ScrapCbfRecord
  class Config
    # Round settings
    class Round < Base
      class << self
        # Default settings
        #
        # @return [Hash]
        def default
          {
            class_name: 'Round',
            rename_attrs: {},
            exclude_attrs_on_create: %i[serie],
            exclude_attrs_on_update: %i[],
            associations: {
              championship: {
                class_name: 'Championship',
                foreign_key: :championship_id
              }
            }
          }
        end

        # Settings use by the system
        # Not configurable
        #
        # @return [Hash]
        def required
          { must_exclude_attrs: %i[matches] }
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

        super(*configs)
      end

      # These method receives the users settings
      #
      # @param [config] Hash contaning the settings
      # @return [nil]
      def config=(config)
        raise ::ArgumentError, 'config must be a Hash' unless config.is_a?(Hash)

        @class_name = config[:class_name]
        @rename_attrs = config[:rename_attrs]
        @exclude_attrs_on_create = config[:exclude_attrs_on_create]
        @exclude_attrs_on_update = config[:exclude_attrs_on_update]
        @associations = config[:associations]

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
