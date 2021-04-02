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

        super(configurations.match, configurations)

        @matches = matches
      end

      # Creates/Updates the matches found on the instance variable matches
      # Update if match already exist, otherwise create it
      #
      # @param [championship_hash] the championship associated with the matches
      # @raise [ActiveRecordError] if fail on saving
      # @return [Boolean] true if not exception is raise
      def create_or_update(championship_hash)
        championship =
          Match.championship.find_by!(year: championship_hash[:year])

        serie = championship_hash[:serie]

        ::ActiveRecord::Base.transaction do
          @matches.each do |hash|
            match = Match.find_by(
              id_match: hash[:id_match],
              championship: championship,
              serie: serie
            )
            round = Match.round.find_by(
              number: hash[:round],
              championship: championship,
              serie: serie
            )
            team = Match.team.find_by(name: hash[:team])
            opponent = Match.opponent.find_by(name: hash[:opponent])

            # these are the associations found
            # they may be <record> class or a string/integer
            # For string/integer cases, it happens when there aren't association:
            # the config for the record hasn't the specific association,
            # so it returns whatever is in the hash
            associations = {
              championship: championship,
              round: round,
              team: team,
              opponent: opponent
            }

            if match
              hash = normalize_before_update(hash, associations)

              match.assign_attributes(hash)
            else
              hash = normalize_before_create(hash, associations)

              match = @class_match.new(hash)
            end

            save_or_log_error(match)
          end
        end
        true
      end
    end
  end
end
