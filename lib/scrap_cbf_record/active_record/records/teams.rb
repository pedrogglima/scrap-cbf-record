# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    class Teams < Base
      def initialize(teams)
        unless teams.respond_to?(:each)
          raise ::ArgumentError, 'must respond to method each'
        end

        @teams = teams

        record_classes = ScrapCbfRecord.config.record_classes

        super(*record_classes)
      end

      def create_unless_found
        @teams.each do |hash|
          team = find_team(name: hash[:name])
          next if team

          @class_team.create(hash)
        end
      end
    end
  end
end
