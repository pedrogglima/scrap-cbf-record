# frozen_string_literal: true

class ScrapCbfRecord
  class Config
    class Ranking < Base
      class << self
        def default
          {
            class_name: 'Ranking',
            rename_attrs: {},
            exclude_attrs: {},
            associations: %i[
              championship
              team
            ]
          }
        end
      end

      attr_reader :class_name,
                  :rename_attrs,
                  :exclude_attrs,
                  :associations

      def initialize(config)
        @class_name = config[:class_name]

        # verifies with class name const is defined
        class_name_validation(@class_name)

        @rename_attrs = config[:rename_attrs]
        @exclude_attrs = config[:exclude_attrs]
        @associations = config[:associations]

        super(config)
      end
    end
  end
end
