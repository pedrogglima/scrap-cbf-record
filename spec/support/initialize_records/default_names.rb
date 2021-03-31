# frozen_string_literal: true

# With default names
#
record_classes = %w[
  Championship
  Match
  Ranking
  Round
  Team
]

record_classes.each do |record_class|
  # define record classes to specs
  # set ActiveRecord::Base as parent class
  Object.const_set(record_class, Class.new(ActiveRecord::Base))
end
