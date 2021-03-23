# frozen_string_literal: true



require_relative 'scrap_cbf_record/version'
require_relative 'scrap_cbf_record/errors'
require_relative 'scrap_cbf_record/config'
require_relative 'scrap_cbf_record/active_record'

class ScrapCbfRecord
  class << self
    # @return [ScrapCbfRecord::Config]
    def config
      @config ||= Config.new
    end
  end
end
