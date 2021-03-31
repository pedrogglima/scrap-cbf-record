# frozen_string_literal: true

# Set output log to file
#
logger = Logger.new('spec/log/scrap_cbf_record.log')

RSpec.configure do |config|
  config.before(:each) do |_test|
    ScrapCbfRecord::TagLogger.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
