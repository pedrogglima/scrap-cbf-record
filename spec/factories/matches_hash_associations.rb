# frozen_string_literal: true

FactoryBot.define do
  factory :match_hash_associations, class: Hash do
    championship { create(:championship) }
    team { create(:team) }
    opponent { create(:team_opponent) }
    round { create(:round, championship_id: create(:championship).id) }
  end

  factory :match_hash_without_associations, class: Hash do
    championship_year
    match_team
    match_opponent
    match_round
  end
end
