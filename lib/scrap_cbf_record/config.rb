# frozen_string_literal: true

require 'yaml'
require_relative 'config/base'
require_relative 'config/championship'
require_relative 'config/match'
require_relative 'config/ranking'
require_relative 'config/round'
require_relative 'config/team'

class ScrapCbfRecord
  class Config
    attr_accessor :config,
                  :championship,
                  :match,
                  :ranking,
                  :round,
                  :team

    # @return [ScrapCbfRecord::Config]
    def initialize
      current_dir = File.dirname(__FILE__)
      @config = YAML.load_file(current_dir + '/configurations.yml')

      @championship_config = @config[:championship] || Championship.default
      @match_config = @config[:match] || Match.default
      @ranking_config = @config[:ranking] || Ranking.default
      @round_config = @config[:round] || Round.default
      @team_config = @config[:team] || Team.default

      @championship = Championship.new(@championship_config)
      @match = Match.new(@match_config)
      @ranking = Ranking.new(@ranking_config)
      @round = Round.new(@round_config)
      @team = Team.new(@team_config)
    end

    # Return an array with all record classes
    #
    # @return [Array]
    def record_classes
      [
        @championship.constant,
        @match.constant,
        @ranking.constant,
        @round.constant,
        @team.constant
      ]
    end
  end
end
