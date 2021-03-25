# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    # Class responsible for saving rounds to database
    class Rounds < Base
      #
      # @param [rounds] hash contaning the rounds
      # @return [nil]
      def initialize(rounds)
        raise_unless_respond_to_each(rounds, :rounds)

        configurations = ScrapCbfRecord.config

        super(configurations.round, *configurations.record_classes)

        @rounds = rounds
      end

      # Creates the rounds found on the instance variable rounds
      # Create only if doesn't exist, otherwise do nothing
      #
      # @param [championship_hash] the championship associated with the rounds
      # @raise [ActiveRecordError] if fail on saving
      # @return [Boolean] true if not exception is raise
      def create_unless_found(championship_hash)
        championship = find_championship(championship_hash[:year])

        @rounds.each do |hash|
          round = find_round(hash[:number], championship)
          next if round

          hash = normalize_before_create(hash, { championship: championship })

          @class_round.create(hash)
        end
        true
      end
    end
  end
end
