# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    class Rankings < Base
      def initialize(rankings)
        raise_unless_respond_to_each(rankings, :rankings)

        configurations = ScrapCbfRecord.config
        @ranking_config = configurations.ranking

        super(@ranking_config, *configurations.record_classes)

        @rankings = rankings
      end

      def create_or_update(championship)
        championship = find_championship(championship[:year])

        @rankings.each do |hash|
          ranking = find_ranking(hash[:posicao], championship)
          team = find_team(hash[:team])
          next_opponent = find_team(hash[:next_opponent])

          associations = {
            championship: championship,
            team: team,
            next_opponent: next_opponent
          }

          if ranking
            hash = normalize_before_update(hash, associations)

            ranking.update(hash)
          else
            hash = normalize_before_create(hash, associations)

            @class_ranking.create(hash)
          end
        end
      end
    end
  end
end
