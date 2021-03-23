# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    class Rankings < Base
      REMOVE_ATTRS_ON_CREATE = %i[team next_opponent].freeze
      REMOVE_ATTRS_ON_UPDATE = %i[posicao team next_opponent].freeze

      def initialize(rankings)
        unless rankings.respond_to?(:each)
          raise ::ArgumentError, 'must respond to method each'
        end

        @rankings = rankings

        record_classes = ScrapCbfRecord.config.record_classes

        super(*record_classes)
      end

      def create_or_update(championship)
        current_championship = find_championship(championship[:year])

        @rankings.each do |hash|
          ranking = find_ranking(
            hash[:posicao], current_championship
          )
          team = find_team(hash[:team])
          next_opponent = find_team(hash[:next_opponent])

          if ranking
            hash = prepare_hash_before_update(hash, team, next_opponent)

            ranking.update(hash)
          else
            args = [hash, current_championship, team, next_opponent]
            hash = prepare_hash_before_create(*args)

            @class_ranking.create(hash)
          end
        end
      end

      private

      def prepare_hash_before_update(hash, team, next_opponent)
        hash[:team_id] = team.id
        hash[:next_opponent_id] = nil_or_next_opponent(next_opponent)

        hash = hash.except(*REMOVE_ATTRS_ON_UPDATE)

        hash
      end

      def prepare_hash_before_create(
        hash,
        championship,
        team,
        next_opponent
      )
        hash[:championship_id] = championship.id
        hash[:team_id] = team.id
        hash[:next_opponent_id] = nil_or_next_opponent(next_opponent)

        hash = hash.except(*REMOVE_ATTRS_ON_CREATE)

        hash
      end

      def nil_or_next_opponent(next_opponent)
        next_opponent ? next_opponent.id : nil
      end
    end
  end
end
