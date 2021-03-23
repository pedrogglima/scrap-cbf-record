# frozen_string_literal: true

require 'active_support/core_ext/hash/except'

class ScrapCbfRecord
  class ActiveRecord
    class Rounds < Base
      REMOVE_ATTRS_ON_CREATE = %i[matches].freeze

      def initialize(rounds)
        unless rounds.respond_to?(:each)
          raise ::ArgumentError, 'must respond to method each'
        end

        @rounds = rounds

        record_classes = ScrapCbfRecord.config.record_classes

        super(*record_classes)
      end

      def create_unless_found(championship)
        current_championship = find_championship(championship[:year])

        @rounds.each do |hash|
          round = find_round(hash[:number], current_championship)
          next if round

          hash = prepare_hash_before_create(hash, current_championship)
          @class_round.create(hash)
        end
      end

      private

      def prepare_hash_before_create(hash, championship)
        hash = hash.except(*REMOVE_ATTRS_ON_CREATE)
        hash[:championship_id] = championship.id

        hash
      end
    end
  end
end
