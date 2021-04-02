# frozen_string_literal: true

class ScrapCbfRecord
  # Abstraction for the class Ranking
  class Ranking < Base
    class << self
      attr_accessor :config

      def championship
        ActiveRecordRelation.new(
          Championship,
          @config.championship_associate?
        )
      end

      def team
        ActiveRecordRelation.new(
          Team,
          @config.team_associate?
        )
      end

      def next_opponent
        ActiveRecordRelation.new(
          Team,
          @config.next_opponent_associate?
        )
      end

      def find_by(attributes)
        position     = attributes[:position]
        championship = attributes[:championship]
        serie        = attributes[:serie]

        if @config.championship_associate?
          find_ranking_associated(position, championship)
        else
          find_ranking(position, championship, serie)
        end
      end

      def find_ranking(position, championship, serie)
        @config.klass.find_by(
          "#{@config.searchable_attr(:position)}": position,
          "#{@config.searchable_attr(:championship)}": championship,
          "#{@config.searchable_attr(:serie)}": serie
        )
      end

      def find_ranking_associated(position, championship)
        @config.klass.find_by(
          "#{@config.searchable_attr(:position)}": position,
          "#{@config.searchable_attr(:championship_id)}": championship.id
        )
      end
    end
  end
end
