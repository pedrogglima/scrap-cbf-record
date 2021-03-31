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

# With classes without fk associations
#
without_association_record_class = %w[
  MatchWithoutAssociation
  RankingWithoutAssociation
  RoundWithoutAssociation
]

without_association_record_class.each do |record_class|
  # define record classes to specs
  # set ActiveRecord::Base as parent class
  Object.const_set(record_class, Class.new(ActiveRecord::Base))
end

# With classes for testing Active Record validation on save
# Note: they share schema table.
#
class MatchWithValidation < ActiveRecord::Base
  self.table_name = 'matches'

  validates :id_match, presence: true
end

class RankingWithValidation < ActiveRecord::Base
  self.table_name = 'rankings'

  validates :position, presence: true
end

class RoundWithValidation < ActiveRecord::Base
  self.table_name = 'rounds'

  validates :number, presence: true
end

class TeamWithValidation < ActiveRecord::Base
  self.table_name = 'teams'

  validates :name, presence: true
end
