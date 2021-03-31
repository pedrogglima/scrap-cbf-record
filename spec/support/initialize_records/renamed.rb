# frozen_string_literal: true

# With classes renamed
#
renamed_record_class = %w[
  Cup
  Game
  TableRow
  Serie
  Club
]

renamed_record_class.each do |record_class|
  # define record classes to specs
  # set ActiveRecord::Base as parent class
  Object.const_set(record_class, Class.new(ActiveRecord::Base))
end
