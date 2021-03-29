# frozen_string_literal: true

FactoryBot.define do
  factory :ranking_hash, class: Hash do
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
            goals_against: ranking_goals_against,
            goal_difference: ranking_goal_difference,
            yellow_card: ranking_yellow_cards,
            red_card: ranking_red_cards,
            advantages: ranking_advantages,
            form: ranking_form
          })
    end
  end
end
