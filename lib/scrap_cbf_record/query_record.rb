# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    # Class for encapsulate logic for querying db data
    class QueryRecord
      def initialize(current_config)
        config = ScrapCbfRecord.config

        # classes set by users
        # e.g @class_championship => # may be Cup class
        #
        @class_championship = config.championship.constant
        @class_match = config.match.constant
        @class_ranking = config.ranking.constant
        @class_round = config.round.constant
        @class_team = config.team.constant

        # current config is associated with the current record class
        #
        @current_config = current_config
        # configs associated with the record classes
        #
        @config_match = config.match
        @config_ranking = config.ranking
        @config_round = config.round
        @config_team = config.team
      end

      def find_championship!(year)
        instance = if @current_config.championship_associate? ||
                      @current_config.record_is_a?(:championship)

                     @class_championship.find_by(year: year)
                   else
                     year
                   end

        raise ChampionshipInstanceNotFoundError, year unless instance

        instance
      end

      def find_match(id_match, championship, serie)
        if @current_config.championship_associate?
          find_match_with_association_fk(id_match, championship)
        else
          find_match_without_association_fk(id_match, championship, serie)
        end
      end

      def find_match_with_association_fk(id_match, championship)
        @class_match.find_by(
          "#{@config_match.searchable_attr(:id_match)}": id_match,
          "#{@config_match.searchable_attr(:championship_id)}": championship.id
        )
      end

      def find_match_without_association_fk(id_match, championship, serie)
        @class_match.find_by(
          "#{@config_match.searchable_attr(:id_match)}": id_match,
          "#{@config_match.searchable_attr(:championship)}": championship,
          "#{@config_match.searchable_attr(:serie)}": serie
        )
      end

      def find_ranking(position, championship, serie)
        if @current_config.championship_associate?
          find_ranking_with_association_fk(position, championship)
        else
          find_ranking_without_association_fk(position, championship, serie)
        end
      end

      def find_ranking_with_association_fk(position, championship)
        @class_ranking.find_by(
          "#{@config_ranking.searchable_attr(:position)}": position,
          "#{@config_ranking.searchable_attr(:championship_id)}": championship.id
        )
      end

      def find_ranking_without_association_fk(position, championship, serie)
        @class_ranking.find_by(
          "#{@config_ranking.searchable_attr(:position)}": position,
          "#{@config_ranking.searchable_attr(:championship)}": championship,
          "#{@config_ranking.searchable_attr(:serie)}": serie
        )
      end

      def find_round(number, championship, serie)
        if @current_config.round_associate? || @current_config.record_is_a?(:round)
          find_round_on_database(number, championship, serie)
        else
          number
        end
      end

      def find_round_on_database(number, championship, serie)
        if @current_config.championship_associate?
          find_round_with_association_fk(number, championship)
        else
          find_round_without_association_fk(number, championship, serie)
        end
      end

      def find_round_with_association_fk(number, championship)
        @class_round.find_by(
          "#{@config_round.searchable_attr(:number)}": number,
          "#{@config_round.searchable_attr(:championship_id)}": championship.id
        )
      end

      def find_round_without_association_fk(number, championship, serie)
        @class_round.find_by(
          "#{@config_round.searchable_attr(:number)}": number,
          "#{@config_round.searchable_attr(:championship)}": championship,
          "#{@config_round.searchable_attr(:serie)}": serie
        )
      end

      def find_team(name)
        if @current_config.team_associate? || @current_config.record_is_a?(:team)
          @class_team.find_by("#{@config_team.searchable_attr(:name)}": name)
        else
          name
        end
      end
    end
  end
end
