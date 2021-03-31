# frozen_string_literal: true

require 'active_support/logger'
require 'active_support/tagged_logging'

class ScrapCbfRecord
  class TagLogger
    class << self
      attr_writer :logger

      def logger
        @logger ||= ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
      end

      def with_context(tags, message)
        logger.tagged(*tags) { logger.info message }
      end
    end
  end
end
