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

        super(configurations.ranking, configurations)

        @query = QueryRecord.new(configurations.ranking)
        @rankings = rankings
      end

      # Creates/Updates the matches found on the instance variable rankings
      # Update if ranking already exist, otherwise create it.
      #
      # @param [championship_hash] the championship associated with the rankings
      # @raise [ActiveRecordError] if fail on saving
      # @return [Boolean] true if not exception is raise
      def create_or_update(championship_hash)
        championship = @query.find_championship!(championship_hash[:year])
        serie = championship_hash[:serie]

        ::ActiveRecord::Base.transaction do
          @rankings.each do |hash|
            ranking = @query.find_ranking(hash[:position], championship, serie)
            team = @query.find_team(hash[:team])
            next_opponent = @query.find_team(hash[:next_opponent])

            # these are the associations found
            # they may be <record> class or a string/integer
            # For string/integer cases, it happens when there aren't association:
            # the config for the record hasn't the specific association,
            # so it returns whatever is in the hash
            associations = {
              championship: championship,
              team: team,
              next_opponent: next_opponent
            }

            if ranking
              hash = normalize_before_update(hash, associations)

              ranking.assign_attributes(hash)
            else
              hash = normalize_before_create(hash, associations)

              ranking = @class_ranking.new(hash)
            end

            save_or_log_error(ranking)
          end
        end
        true
      end
    end
  end
end
