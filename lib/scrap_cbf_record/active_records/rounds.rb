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

        super(configurations.round)

        @rounds = rounds
      end

      # Creates the rounds found on the instance variable rounds
      # Create only if doesn't exist, otherwise do nothing
      #
      # @param [championship_hash] the championship associated with the rounds
      # @raise [ActiveRecordError] if fail on saving
      # @return [Boolean] true if not exception is raise
      def create_unless_found(championship_hash)
        championship, serie = find_championship_by(championship_hash)

        ::ActiveRecord::Base.transaction do
          @rounds.each do |hash|
            round = Round.find_by(
              number: hash[:number],
              championship: championship,
              serie: serie
            )
            next if round

            hash = normalize_before_create(hash, { championship: championship })

            round = Round.new(hash)

            save_or_log_error(round)
          end
        end
        true
      end

      private

      def find_championship_by(championship_hash)
        championship =
          Round.championship.find_by!(year: championship_hash[:year])

        serie = championship_hash[:serie]

        [championship, serie]
      end
    end
  end
end
