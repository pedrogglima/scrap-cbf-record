# frozen_string_literal: true

FactoryBot.define do
  factory :ranking_hash_associations, class: Hash do
    championship { create(:championship) }
    team { create(:team) }
    next_opponent { create(:team_opponent) }
  end

  factory :ranking_hash_without_associations, class: Hash do
    championship_year
    ranking_team
    ranking_next_opponent
  end
end
