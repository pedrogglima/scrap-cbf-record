# frozen_string_literal: true

class ScrapCbfRecord
  class Config
    class Ranking < Base
      class << self
        def default
          {
            class_name: 'Ranking',
            rename_attrs: {},
            exclude_attrs_on_create: %i[],
            exclude_attrs_on_update: %i[],
            associations: %i[
              championship
              team
            ]
          }
        end
      end

      attr_reader :class_name,
                  :rename_attrs,
                  :exclude_attrs_on_create,
                  :exclude_attrs_on_update,
                  :associations

      def initialize
        @class_name = default_class_name
        @rename_attrs = default_rename_attrs
        @exclude_attrs_on_create = default_exclude_attrs_on_create
        @exclude_attrs_on_update = default_exclude_attrs_on_update
        @associations = default_associations

        super(*configs)
      end

      def config=(config)
        raise ::ArgumentError, 'config must be a Hash' unless config.is_a?(Hash)

        @class_name = config[:class_name]
        @rename_attrs = config[:rename_attrs]
        @exclude_attrs_on_create = config[:exclude_attrs_on_create]
        @exclude_attrs_on_update = config[:exclude_attrs_on_update]
        @associations = config[:associations]

        super(*configs)
      end

      def configs
        [
          @class_name,
          @rename_attrs,
          @exclude_attrs_on_create,
          @exclude_attrs_on_update,
          @associations
        ]
      end

      def remove_attrs_based_on_assoc
        @remove_attrs_based_on_assoc ||= remove_attrs
      end

      private

      def remove_attrs
        remove_attrs = []

        remove_attrs << :championship if championship_assoc?
        remove_attrs << :team if team_assoc?
        remove_attrs << :next_opponent if team_assoc?

        remove_attrs
      end
    end
  end
end
