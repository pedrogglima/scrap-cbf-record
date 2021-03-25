# frozen_string_literal: true

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

renamed_record_class = %w[
  Cup
  Game
  TableRow
  Series
  Club
]

renamed_record_class.each do |record_class|
  # define record classes to specs
  # set ActiveRecord::Base as parent class
  Object.const_set(record_class, Class.new(ActiveRecord::Base))
end
