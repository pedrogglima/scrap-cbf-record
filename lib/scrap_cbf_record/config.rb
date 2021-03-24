# frozen_string_literal: true

require_relative 'config/base'
require_relative 'config/championship'
require_relative 'config/match'
require_relative 'config/ranking'
require_relative 'config/round'
require_relative 'config/team'

class ScrapCbfRecord
  class Config
    class << self
    end

    attr_accessor :championship,
                  :match,
                  :ranking,
                  :round,
                  :team

    # @return [ScrapCbfRecord::Config]
    def initialize
      @championship = Championship.new
      @match = Match.new
      @ranking = Ranking.new
      @round = Round.new
      @team = Team.new
    end

    # Return an array with all record const classes
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
