# frozen_string_literal: true

class ScrapCbfRecord
  class Config
    class Base
      def initialize(config)
        @class_name = config[:class_name]
        @rename_attrs = config[:rename_attrs]
        @exclude_attrs = config[:exclude_attrs]
        @associations = config[:associations]
      end

      def constant
        Object.const_get(@class_name)
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
    end
  end
end
