# frozen_string_literal: true

require_relative 'scrap_cbf_record/version'
require_relative 'scrap_cbf_record/errors'
require_relative 'scrap_cbf_record/config'
require_relative 'scrap_cbf_record/active_record'

class ScrapCbfRecord
  class << self
    # @return [ScrapCbfRecord::Config]
    def config
      @config ||= settings
    end

    # @return [ScrapCbfRecord::Config]
    def settings
      configuration = Config.new

      yield configuration if block_given?

      @config = configuration
    end
  end
end
