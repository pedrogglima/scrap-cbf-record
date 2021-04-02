# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    # Class responsible for saving matches to database
    class Matches < Base
      #
      # @param [matches] hash contaning the matches
      # @return [nil]
      def initialize(matches)
        raise_unless_respond_to_each(matches, :matches)

        configurations = ScrapCbfRecord.config

        super(configurations.match)

        @matches = matches
      end

      # Creates/Updates the matches found on the instance variable matches
      # Update if match already exist, otherwise create it
      #
      # @param [championship_hash] the championship associated with the matches
      # @raise [ActiveRecordError] if fail on saving
      # @return [Boolean] true if not exception is raise
      def create_or_update(championship_hash)
        championship, serie = find_championship_by(championship_hash)

        ::ActiveRecord::Base.transaction do
          @matches.each do |hash|
            attrs = [hash, championship, serie]
            match = find_match_by(*attrs)
            round = find_round_by(*attrs)
            team = Match.team.find_by(name: hash[:team])
            opponent = Match.opponent.find_by(name: hash[:opponent])

            associations = {
              championship: championship,
              round: round,
              team: team,
              opponent: opponent
            }

            match = normalize_before_save(match, hash, associations)

            save_or_log_error(match)
          end
        end
        true
      end

      private

      def find_championship_by(championship_hash)
        championship =
          Match.championship.find_by!(year: championship_hash[:year])

        serie = championship_hash[:serie]

        [championship, serie]
      end

      def find_match_by(hash, championship, serie)
        Match.find_by(
          id_match: hash[:id_match],
          championship: championship,
          serie: serie
        )
      end

      def find_round_by(hash, championship, serie)
        Match.round.find_by(
          number: hash[:round],
          championship: championship,
          serie: serie
        )
      end
    end
  end
end
