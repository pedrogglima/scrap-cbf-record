# frozen_string_literal: true

FactoryBot.define do
  factory :match_hash_associations, class: Hash do
    championship { create(:championship).id }
    team { create(:team).id }
    opponent { create(:team_opponent).id }
    round { create(:round, championship_id: create(:championship).id).id }

    initialize_with do
      new({
            championship: championship,
            team: team,
            opponent: opponent,
            round: round
          })
    end
  end

  factory :match_hash_without_associations, class: Hash do
    championship_year
    match_team
    match_opponent
    match_round

    initialize_with do
      new({
            championship: championship_year,
            team: match_team,
            opponent: match_opponent,
            round: match_round
          })
    end
  end
end
