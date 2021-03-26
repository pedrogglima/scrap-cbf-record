# frozen_string_literal: true

require_relative 'config/base'
require_relative 'config/championship'
require_relative 'config/match'
require_relative 'config/ranking'
require_relative 'config/round'
require_relative 'config/team'

class ScrapCbfRecord
  # This class is responsible for holding the configs on how records
  # must be save on database. That means:
  # - which class to use to save the records
  # - which record attributes to exclude on create and update
  # - which record attributes to rename
  # Each of the configs are set for each record:
  # - match record
  # - ranking record
  # - round record
  # - team record
  class Config
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
