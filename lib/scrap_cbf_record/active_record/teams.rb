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

        @teams = teams
      end

      # Creates the teams found on the instance variable teams
      # Create only if doesn't exist, otherwise do nothing
      #
      # @raise [ActiveRecordError] if fail on saving
      # @return [Boolean] true if not exception is raise
      def create_unless_found
        @teams.each do |hash|
          team = find_team(hash[:name])
          next if team

          hash = normalize_before_create(hash)

          @class_team.create(hash)
        end
        true
      end
    end
  end
end
