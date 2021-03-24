# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    class Teams < Base
      def initialize(teams)
        raise_unless_respond_to_each(teams, :teams)

        configurations = ScrapCbfRecord.config
        @team_config = configurations.team

        super(@team_config, *configurations.record_classes)

        @teams = teams
      end

      def create_unless_found
        @teams.each do |hash|
          team = find_team(hash[:name])
          next if team

          hash = normalize_before_create(hash)

          @class_team.create(hash)
        end
      end
    end
  end
end
