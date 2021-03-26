# frozen_string_literal: true

FactoryBot.define do
  factory :team_hash, class: Hash do
    team_name
    team_state
    team_avatar_url

    initialize_with do
      new(
        name: team_name,
        state: team_state,
        avatar_url: team_avatar_url
      )
    end
  end
end

FactoryBot.define do
  factory :team_opponent_hash, class: Hash do
    team_opponent_name
    team_state
    team_avatar_url

    initialize_with do
      new(
        name: team_opponent_name,
        state: team_state,
        avatar_url: team_avatar_url
      )
    end
  end
end
