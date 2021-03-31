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
  end

  factory :invalid_match_hash, class: Hash do
    championship_year
    championship_serie
    match_team
    match_opponent
    match_round
    match_team_score
    match_opponent_score
    match_updates
    match_date
    match_start_at
    match_place
  end
end
