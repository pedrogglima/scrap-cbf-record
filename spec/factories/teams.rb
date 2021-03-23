# frozen_string_literal: true

FactoryBot.define do
  factory :team, class: Team do
    name { 'Team' }
    state { 'state_1' }
    avatar_url { 'avatar_url_1' }

    initialize_with do
      Team.where(name: 'Team').first_or_create
    end
  end

  factory :team_opponent, class: Team do
    name { 'Team Opponent' }
    state { 'state_1' }
    avatar_url { 'avatar_url_1' }

    initialize_with do
      Team.where(name: 'Team Opponent').first_or_create
    end
  end
end
