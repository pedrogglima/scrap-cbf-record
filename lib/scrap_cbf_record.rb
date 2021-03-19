# frozen_string_literal: true

require 'active_support/core_ext/hash/except'

require_relative 'scrap_cbf_record/version'
require_relative 'scrap_cbf_record/errors'
require_relative 'scrap_cbf_record/config'
require_relative 'scrap_cbf_record/active_record'
require_relative 'scrap_cbf_record/active_record/records/base'
require_relative 'scrap_cbf_record/active_record/records/matches'
require_relative 'scrap_cbf_record/active_record/records/rankings'
require_relative 'scrap_cbf_record/active_record/records/rounds'
require_relative 'scrap_cbf_record/active_record/records/teams'
require_relative 'scrap_cbf_record/active_record/record'

class ScrapCbfRecord
  class << self
    # @return [ScrapCbfRecord::Config]
    def config
      @config ||= record_settings
    end

    # Pass through block a new instance of ScrapCbfRecord::Config.
    #
    # @return [ScrapCbfRecord::Config]
    def record_settings
      configurations = Config.new

      yield configurations if block_given?

      configurations.validate

      @config = configurations
    end
  end
end
