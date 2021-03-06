# frozen_string_literal: true

class ScrapCbfRecord
  # Abstraction for the class Match
  class Match < Base
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

      # Find the current model on db. If current model is associate
      #  to championship, the attribute serie is not need, as the
      #  association can be used as a unique identifer for the model.
      #
      # @param attributes [Hash] the attrs used to find on db
      # @return [Object, nil] returns Object if find, else nil
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
