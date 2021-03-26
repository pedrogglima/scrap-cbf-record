# frozen_string_literal: true

FactoryBot.define do
  factory :match_hash_normalized, class: Hash do
    cup_id { create(:championship).id }
    match_team_id { create(:team).id }
    team_opponent_id { create(:team_opponent).id }
    match_round_id do
      create(:round, championship_id: create(:championship).id).id
    end
    match_identifier
    match_team_score
    match_opponent_score
    match_date
    match_start_at
    match_place

    initialize_with do
      new({
            cup_id: cup_id,
            match_team_id: match_team_id,
            team_opponent_id: team_opponent_id,
            match_round_id: match_round_id,
            identifier: match_identifier,
            team_score: match_team_score,
            opponent_score: match_opponent_score,
            date: match_date,
            start_at: match_start_at,
            place: match_place
          })
    end
  end

  factory :match_hash_normalized_without_association, class: Hash do
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
