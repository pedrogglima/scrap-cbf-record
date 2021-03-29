# frozen_string_literal: true

FactoryBot.define do
  factory :ranking_hash_normalized, class: Hash do
    cup_id { create(:championship).id }
    rank_team_id { create(:team).id }
    next_team_opponent_id { create(:team_opponent).id }
    ranking_rank
    ranking_points
    ranking_played
    ranking_won
    ranking_drawn
    ranking_lost
    ranking_advantages
    ranking_form

    initialize_with do
      new({
            cup_id: cup_id,
            rank_team_id: rank_team_id,
            next_team_opponent_id: next_team_opponent_id,
            rank: ranking_rank,
            points: ranking_points,
            played: ranking_played,
            won: ranking_won,
            drawn: ranking_drawn,
            lost: ranking_lost,
            advantages: ranking_advantages,
            form: ranking_form
          })
    end
  end

  factory :ranking_hash_normalized_without_association, class: Hash do
    championship_year
    championship_serie
    ranking_team
    ranking_next_opponent
    ranking_position
    ranking_points
    ranking_played
    ranking_won
    ranking_drawn
    ranking_lost
    ranking_goals_for
    ranking_goals_against
    ranking_goal_difference
    ranking_yellow_cards
    ranking_red_cards
    ranking_advantages
    ranking_form

    initialize_with do
      new({
            championship: championship_year,
            serie: championship_serie,
            team: ranking_team,
            next_opponent: ranking_next_opponent,
            position: ranking_position,
            points: ranking_points,
            played: ranking_played,
            won: ranking_won,
            drawn: ranking_drawn,
            lost: ranking_lost,
            goals_for: ranking_goals_against,
            goals_contra: ranking_goals_against,
            saldo_de_goals: ranking_goal_difference,
            cartoes_amarelos: ranking_yellow_cards,
            cartoes_vermelhos: ranking_red_cards,
            advantages: ranking_advantages,
            form: ranking_form
          })
    end
  end
end
