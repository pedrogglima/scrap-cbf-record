# frozen_string_literal: true

FactoryBot.define do
  factory :matches_attrs, class: Array do
    initialize_with do
      %i[
        championship
        serie
        round
        team
        opponent
        id_match
        team_score
        opponent_score
        updates
        date
        start_at
        place
      ]
    end
  end
end
