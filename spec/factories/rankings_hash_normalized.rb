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
  end
end
