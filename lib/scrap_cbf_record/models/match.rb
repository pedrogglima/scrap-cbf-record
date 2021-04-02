# frozen_string_literal: true

class ScrapCbfRecord
  # Represents the class Match
  class Match
    class << self
      attr_accessor :config

      def championship
        ActiveRecordRelation.new(
          Championship,
          @config.championship_associate?
        )
      end

      def round
        ActiveRecordRelation.new(
          Round,
          @config.round_associate?
        )
      end

      def team
        ActiveRecordRelation.new(
          Team,
          @config.team_associate?
        )
      end

      def opponent
        ActiveRecordRelation.new(
          Team,
          @config.opponent_associate?
        )
      end

      def find_by(attributes)
        id_match     = attributes[:id_match]
        championship = attributes[:championship]
        serie        = attributes[:serie]

        if @config.championship_associate?
          find_match_associated(id_match, championship)
        else
          find_match(id_match, championship, serie)
        end
      end

      def find_match(id_match, championship, serie)
        @config.klass.find_by(
          "#{@config.searchable_attr(:id_match)}": id_match,
          "#{@config.searchable_attr(:championship)}": championship,
          "#{@config.searchable_attr(:serie)}": serie
        )
      end

      def find_match_associated(id_match, championship)
        @config.klass.find_by(
          "#{@config.searchable_attr(:id_match)}": id_match,
          "#{@config.searchable_attr(:championship_id)}": championship.id
        )
      end
    end
  end
end
