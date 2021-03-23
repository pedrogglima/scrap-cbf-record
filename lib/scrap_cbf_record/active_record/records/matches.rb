# frozen_string_literal: true

require 'active_support/core_ext/hash/except'

class ScrapCbfRecord
  class ActiveRecord
    class Matches < Base
      REMOVE_ATTRS_ON_CREATE = %i[team opponent round].freeze
      REMOVE_ATTRS_ON_UPDATE = %i[team opponent id_match round].freeze

      def initialize(matches)
        unless matches.respond_to?(:each)
          raise ::ArgumentError, 'must respond to method each'
        end

        @matches = matches

        record_classes = ScrapCbfRecord.config.record_classes

        super(*record_classes)
      end

      def create_or_update(championship)
        current_championship = find_championship(championship[:year])

        @matches.each do |hash|
          
          match = find_match(hash[:id_match], current_championship)
          round = find_round(hash[:round], current_championship)
          team = find_team(hash[:team])
          opponent = find_team(hash[:opponent])

          if match
            hash = prepare_hash_before_update(hash)
            match.update(hash)
          else
            args = [hash, current_championship, round, team, opponent]
            hash = prepare_hash_before_create(*args)

            @class_match.create(hash)
          end
        end
      end

      private

      def prepare_hash_before_update(hash)
        hash = hash.except(*REMOVE_ATTRS_ON_UPDATE)

        hash
      end

      def prepare_hash_before_create(
        hash,
        championship,
        round,
        team,
        next_opponent
      )
        hash = hash.except(*REMOVE_ATTRS_ON_CREATE)
        hash[:championship_id] = championship.id
        hash[:round_id] = round.id
        hash[:team_id] = team.id
        hash[:opponent_id] = next_opponent.id

        hash
      end
    end
  end
end
