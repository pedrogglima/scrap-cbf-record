# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    class Rounds < Base
      def initialize(rounds)
        raise_unless_respond_to_each(rounds, :rounds)

        configurations = ScrapCbfRecord.config
        @round_config = configurations.round

        super(@round_config, *configurations.record_classes)

        @rounds = rounds
      end

      def create_unless_found(championship)
        championship = find_championship(championship[:year])

        @rounds.each do |hash|
          round = find_round(hash[:number], championship)
          next if round

          hash = normalize_before_create(hash, { championship: championship })

          @class_round.create(hash)
        end
      end
    end
  end
end
