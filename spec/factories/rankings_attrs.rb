# frozen_string_literal: true

FactoryBot.define do
  factory :rankings_attrs, class: Array do
    initialize_with do
      %i[
        championship
        serie
        position
        team
        points
        played
        won
        drawn
        lost
        goals_for
        goals_against
        goal_difference
        yellow_card
        red_card
        advantages
        form
        next_opponent
      ]
    end
  end
end
