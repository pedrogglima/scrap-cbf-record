# frozen_string_literal: true

FactoryBot.define do
  factory :match_hash, class: Hash do
    team { create(:team)[:name] }
    opponent { create(:team_opponent)[:name] }
    round { attributes_for(:round)[:number] }
    id_match { 1 }
    team_score { 1 }
    opponent_score { 1 }
    updates { 1 }
    date { '12/03/2020 18:00' }
    start_at { '18:00' }
    place { 'Stadium Test' }

    initialize_with {
      new({

        team: team,
        opponent: opponent,
        round: round,
        id_match: id_match,
        team_score: team_score,
        opponent_score: opponent_score,
        updates: updates,
        date: date,
        start_at: start_at,
        place: place
      })
    }
  end
end
