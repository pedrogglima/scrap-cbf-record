# frozen_string_literal: true

class ScrapCbfRecord
  class Config
    # Ranking settings
    class Ranking < Base
      class << self
        # Default settings
        #
        # @return [Hash]
        def default
          {
            class_name: 'Ranking',
            rename_attrs: {},
            exclude_attrs_on_create: %i[serie],
            exclude_attrs_on_update: %i[serie],
            associations: {
              championship: {
                class_name: 'Championship',
                foreign_key: :championship_id
              },
              team: {
                class_name: 'Team',
                foreign_key: :team_id
              },
              next_opponent: {
                class_name: 'Team',
                foreign_key: :next_opponent_id
              }
            }
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
            championship
            serie
            position
            team
            points
            played
            won
            drawn
            lost
            goals_for
            goals_against
            goal_difference
            yellow_card
            red_card
            advantages
            form
            next_opponent
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

        ScrapCbfRecord::Ranking.config = self

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

      # Check if config has specific association.
      #
      # @return [Boolean]
      def championship_associate?
        return false unless associations?

        @championship_associate ||= @associations.key?(:championship)
      end

      # Check if config has specific association.
      #
      # @return [Boolean]
      def team_associate?
        return false unless associations?

        @team_associate ||= @associations.key?(:team)
      end

      # Check if current config has specific setting association.
      #
      # @return [Boolean]
      def next_opponent_associate?
        return false unless associations?

        @next_opponent_associate ||= @associations.key?(:next_opponent)
      end
    end
  end
end
