# frozen_string_literal: true

require 'json'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/except'

require_relative 'active_record/base'
require_relative 'active_record/matches'
require_relative 'active_record/rankings'
require_relative 'active_record/rounds'
require_relative 'active_record/teams'

class ScrapCbfRecord
  class ActiveRecord
    class << self
      def save(records)
        new(records).save

        true
      end
    end

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
    #  there is a saving order.
    # - Teams must be save before Rankings and Match.
    # - Rounds must be save before Matches
    #
    # Raise Active Record errors in case of fail while saving
    #
    # @return [true]
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
