# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    # Class responsible for saving rankings to database
    class Rankings < Base
      #
      # @param [rankings] hash contaning the rankings
      # @return [nil]
      def initialize(rankings)
        raise_unless_respond_to_each(rankings, :rankings)

        configurations = ScrapCbfRecord.config

        super(configurations.ranking)

        @rankings = rankings
      end

      # Creates/Updates the matches found on the instance variable rankings
      # Update if ranking already exist, otherwise create it.
      #
      # @param [championship_hash] the championship associated with the rankings
      # @raise [ActiveRecordValidationError] if fail on saving
      # @return [Boolean] true if not exception is raise
      def create_or_update(championship_hash)
        championship, serie = find_championship_by(championship_hash)

        ::ActiveRecord::Base.transaction do
          @rankings.each do |hash|
            ranking = find_ranking_by(hash, championship, serie)
            team = Ranking.team.find_by(name: hash[:team])
            next_opponent =
              Ranking.next_opponent.find_by(name: hash[:next_opponent])

            associations = {
              championship: championship,
              team: team,
              next_opponent: next_opponent
            }

            ranking = normalize_before_save(ranking, hash, associations)

            save_or_log_error(ranking)
          end
        end
        true
      end

      private

      def find_championship_by(championship_hash)
        championship =
          Ranking.championship.find_by!(year: championship_hash[:year])

        serie = championship_hash[:serie]

        [championship, serie]
      end

      def find_ranking_by(hash, championship, serie)
        Ranking.find_by(
          position: hash[:position],
          championship: championship,
          serie: serie
        )
      end
    end
  end
end
