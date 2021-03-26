# frozen_string_literal: true

FactoryBot.define do
  factory :ranking_hash_associations, class: Hash do
    championship { create(:championship).id }
    team { create(:team).id }
    next_opponent { create(:team_opponent).id }

    initialize_with do
      new({
            championship: championship,
            team: team,
            next_opponent: next_opponent
          })
    end
  end

  factory :ranking_hash_without_associations, class: Hash do
    championship_year
    ranking_team
    ranking_next_opponent

    initialize_with do
      new({
            championship: championship_year,
            team: ranking_team,
            next_opponent: ranking_next_opponent
          })
    end
  end
end
