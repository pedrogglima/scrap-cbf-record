# frozen_string_literal: true

class ScrapCbfRecord
  class Config
    class Round < Base
      class << self
        def default
          {
            class_name: 'Round',
            rename_attrs: {},
            exclude_attrs_on_create: %i[],
            exclude_attrs_on_update: %i[],
            associations: %i[championship]
          }
        end

        def required
          {
            must_not_rename_attrs: %i[id],
            must_exclude_attrs: %i[matches],
            must_keep_attrs: %i[id number year]
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
    end
  end
end
