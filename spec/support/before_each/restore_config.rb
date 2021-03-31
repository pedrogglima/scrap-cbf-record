# frozen_string_literal: true

# Restore singleton ScrapCbfRecord::Config to default.
# We need that because there are some tests that change it
# but doesn't restore after, which leads to a undesired config state
# for the next test.
#
RSpec.configure do |config|
  config.before(:each) do |_test|
    ScrapCbfRecord.config.restore
  end
end
