# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    # Class responsible for saving teams to database
    class Teams < Base
      #
      # @param [teams] hash contaning the teams
      # @return [nil]
      def initialize(teams)
        raise_unless_respond_to_each(teams, :teams)

        configurations = ScrapCbfRecord.config

        super(configurations.team, configurations)

        @query = QueryRecord.new(configurations.team)
        @teams = teams
      end

      # Creates the teams found on the instance variable teams
      # Create only if doesn't exist, otherwise do nothing
      #
      # @raise [ActiveRecordError] if fail on saving
      # @return [Boolean] true if not exception is raise
      def create_unless_found
        ::ActiveRecord::Base.transaction do
          @teams.each do |hash|
            team = @query.find_team(hash[:name])
            next if team

            hash = normalize_before_create(hash)

            team = @class_team.new(hash)

            save_or_log_error(team)
          end
        end
        true
      end
    end
  end
end
