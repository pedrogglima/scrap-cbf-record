# frozen_string_literal: true

require 'json'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/except'

require_relative 'active_records/base'
require_relative 'active_records/matches'
require_relative 'active_records/rankings'
require_relative 'active_records/rounds'
require_relative 'active_records/teams'

class ScrapCbfRecord
  # This module uses Active Record module to save data on database.
  class ActiveRecord
    class << self
      def save(records)
        new(records).save

        true
      end
    end

    # The argument records is a hash (json or not) with the following look :
    # - hash[:championship] the championship for a specific year and divison
    # - hash[:matches] the matches for the specific championship
    # - hash[:rankings] the rankings for the specific championship
    # - hash[:rounds] the rounds for the specific championship
    # - hash[:teams] the teams that participated on the specific championship
    #
    # @param [records] hash or json returned from ScrapCbf gem
    # @return [nil]
    def initialize(records)
      records = parse_json!(records) if records.is_a?(String)

      raise ::ArgumentError, invalid_type_message unless records.is_a?(Hash)

      @records = records.with_indifferent_access

      validate_record_key_presence!(@records)

      @championship = @records[:championship]
      @matches = @records[:matches]
      @rankings = @records[:rankings]
      @rounds = @records[:rounds]
      @teams = @records[:teams]
    end

    # Save records to the database.
    # Note: Because of database relationships and dependencies between records
    #  there maybe exist a saving order.
    # - Teams must be save before Rankings and Match.
    # - Rounds must be save before Matches
    #
    # @raise [ActiveRecordError] errors in case of failing while saving
    #
    # @return [Boolean] true in case of success
    def save
      save_teams(@teams)
      save_rankings(@rankings, @championship)
      save_rounds(@rounds, @championship)
      save_matches(@matches, @championship)

      true
    end

    private

    def save_teams(teams)
      Teams.new(teams).create_unless_found
    end

    def save_rankings(rankings, championship)
      Rankings.new(rankings).create_or_update(championship)
    end

    def save_rounds(rounds, championship)
      Rounds.new(rounds).create_unless_found(championship)
    end

    def save_matches(matches, championship)
      Matches.new(matches).create_or_update(championship)
    end

    def invalid_type_message
      'must be a Hash or Json of a Hash'
    end

    def parse_json!(records)
      JSON.parse(records)
    rescue JSON::ParserError => e
      raise JsonDecodeError, e
    end

    def validate_record_key_presence!(records)
      raise MissingKeyError, 'championship' unless records.key?(:championship)
      raise MissingKeyError, 'matches' unless records.key?(:matches)
      raise MissingKeyError, 'rankings' unless records.key?(:rankings)
      raise MissingKeyError, 'rounds' unless records.key?(:rounds)
      raise MissingKeyError, 'teams' unless records.key?(:teams)

      true
    end
  end
end
