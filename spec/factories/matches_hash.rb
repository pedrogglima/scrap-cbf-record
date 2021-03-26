# frozen_string_literal: true

FactoryBot.define do
  factory :match_hash, class: Hash do
    championship_year
    championship_serie
    match_team
    match_opponent
    match_round
    match_id_match
    match_team_score
    match_opponent_score
    match_updates
    match_date
    match_start_at
    match_place

    initialize_with do
      new({
            championship: championship_year,
            serie: championship_serie,
            team: match_team,
            opponent: match_opponent,
            round: match_round,
            id_match: match_id_match,
            team_score: match_team_score,
            opponent_score: match_opponent_score,
            updates: match_updates,
            date: match_date,
            start_at: match_start_at,
            place: match_place
          })
    end
  end
end
