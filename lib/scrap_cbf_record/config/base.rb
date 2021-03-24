# frozen_string_literal: true

class ScrapCbfRecord
  class Config
    class Base
      class << self
        def default
          raise NotImplementedError, 'default method must be implemented'
        end

        def required
          raise NotImplementedError, 'required method must be implemented'
        end

        def default_class_name
          default[:class_name]
        end

        def default_rename_attrs
          default[:rename_attrs]
        end

        def default_exclude_attrs_on_create
          default[:exclude_attrs_on_create]
        end

        def default_exclude_attrs_on_update
          default[:exclude_attrs_on_create]
        end

        def default_associations
          default[:associations]
        end

        def must_not_rename_attrs
          required[:must_not_rename_attrs]
        end

        def must_exclude_attrs
          required[:must_exclude_attrs]
        end

        def must_keep_attrs
          required[:must_keep_attrs]
        end
      end

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

      def constant
        Object.const_get(@class_name) if @class_name
      end

      def self_assoc?(self_record)
        config_name = self.class.name.split('::').last

        config_name.downcase == self_record.to_s
      end

      def championship_assoc?
        return false unless @associations

        @championship_assoc ||= @associations.include?(:championship)
      end

      def round_assoc?
        return false unless @associations

        @round_assoc ||= @associations.include?(:round)
      end

      def team_assoc?
        return false unless @associations

        @team_assoc ||= @associations.include?(:team)
      end

      def association?
        !@associations.empty?
      end

      def must_not_rename_attrs
        self.class.must_not_rename_attrs
      end

      def must_exclude_attrs
        self.class.must_exclude_attrs
      end

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
