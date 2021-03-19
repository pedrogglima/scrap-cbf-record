# frozen_string_literal: true

class ScrapCbfRecord
  module ActiveRecord
    class Base
      def initialize(
        championship,
        match,
        ranking,
        round,
        team
      )
        @class_championship = championship
        @class_match = match
        @class_ranking = ranking
        @class_round = round
        @class_team = team
      end

      def find_championship(year)
        @class_championship.find_by(year: year)
      end

      def find_match(id_match, championship)
        @class_match.find_by(
          id_match: id_match,
          championship_id: championship.id
        )
      end

      def find_ranking(posicao, championship)
        @class_ranking.find_by(
          posicao: posicao,
          championship_id: championship.id
        )
      end

      def find_round(number, championship)
        @class_round.find_by(
          number: number,
          championship_id: championship.id
        )
      end

      def find_team(name)
        @class_team.find_by(name: name)
      end
    end
  end
end
