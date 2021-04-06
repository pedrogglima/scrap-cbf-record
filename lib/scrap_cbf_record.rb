# frozen_string_literal: true

require_relative 'scrap_cbf_record/version'
require_relative 'scrap_cbf_record/logger'
require_relative 'scrap_cbf_record/errors'
require_relative 'scrap_cbf_record/models/base'
require_relative 'scrap_cbf_record/models/championship'
require_relative 'scrap_cbf_record/models/match'
require_relative 'scrap_cbf_record/models/ranking'
require_relative 'scrap_cbf_record/models/round'
require_relative 'scrap_cbf_record/models/team'
require_relative 'scrap_cbf_record/models/concerns/active_record_relation'
require_relative 'scrap_cbf_record/config'
require_relative 'scrap_cbf_record/active_record'

# This module saves on database the output from the gem ScrapCbf
#
# It has three modules to accomplish that:
# - configs: holds the settings for how to save the data
# - records: responsible for saving the data on database.
# - models: abstraction classes for the real record classes created by the user.
#
# There configs are:
# - championship
# - match
# - ranking
# - round
# - team
#
# The records are:
# - matches: saves the matches for a specific championship
# - rankings: saves the rankings for a specific championship
# - rounds: saves the rounds for a specific championship
# - teams: saves the teams that participated on the specific champ.
class ScrapCbfRecord
  class << self
    # Returns the global configurations for these module
    #
    # @return [ScrapCbfRecord::Config]
    def config
      @config ||= settings
    end

    # Sets the global configurations
    # We can set the configurations in the following way:
    #
    #   ScrapCbfRecord.settings do |config|
    #     config.championship = {
    #       class_name: 'Championship'
    #       rename_attrs: {},
    #       exclude_attrs_on_create: %i[],
    #       exclude_attrs_on_update: %i[],
    #       associations: {}
    #     }
    #
    #     config.match = { ... }
    #     config.ranking = { ... }
    #     config.round = { ... }
    #     config.team = { ... }
    #   end
    # If a config or a config's attribute was not set,
    # default setting will be used
    #
    # @return [ScrapCbfRecord::Config]
    def settings
      configuration = Config.instance

      yield configuration if block_given?

      @config = configuration
    end
  end
end
