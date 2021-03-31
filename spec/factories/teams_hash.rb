# frozen_string_literal: true

FactoryBot.define do
  factory :team_hash, class: Hash do
    team_name
    team_state
    team_avatar_url
  end

  factory :team_opponent_hash, class: Hash do
    team_opponent_name
    team_state
    team_avatar_url
  end

  factory :invalid_team_hash, class: Hash do
    team_state
    team_avatar_url
  end
end
