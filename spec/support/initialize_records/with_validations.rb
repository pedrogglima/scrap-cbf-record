# frozen_string_literal: true

# With classes for testing Active Record validation on save
# Note: they share schema table with default name.
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
