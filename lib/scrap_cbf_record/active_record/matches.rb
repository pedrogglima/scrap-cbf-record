# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    class Matches < Base
      def initialize(matches)
        raise_unless_respond_to_each(matches, :matches)

        configurations = ScrapCbfRecord.config
        @match_config = configurations.match

        super(@match_config, *configurations.record_classes)

        @matches = matches
      end

      def create_or_update(championship_hash)
        championship = find_championship(championship_hash[:year])

        @matches.each do |hash|
          match = find_match(hash[:id_match], championship)
          round = find_round(hash[:round], championship)
          team = find_team(hash[:team])
          opponent = find_team(hash[:opponent])

          associations = {
            championship: championship,
            round: round,
            team: team,
            opponent: opponent
          }

          if match
            hash = normalize_before_update(hash, associations)

            match.update(hash)
          else
            hash = normalize_before_create(hash, associations)

            @class_match.create(hash)
          end
        end
      end
    end
  end
end
