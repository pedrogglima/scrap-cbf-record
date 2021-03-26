# frozen_string_literal: true

FactoryBot.define do
  trait :team_name do
    name { 'Team' }
  end

  trait :team_opponent_name do
    name { 'Team Opponent' }
  end
  trait :team_state do
    state { 'state' }
  end

  trait :team_avatar_url do
    avatar_url { 'avatar_url' }
  end

  #
  ##################################################################
  #

  factory :team, class: Team do
    team_name
    team_state
    team_avatar_url

    initialize_with do
      Team.where(name: 'Team').first_or_create
    end
  end

  factory :team_opponent, class: Team do
    team_opponent_name
    team_state
    team_avatar_url

    initialize_with do
      Team.where(name: 'Team Opponent').first_or_create
    end
  end

  factory :team_renamed_club, class: Club do
    club_name { 'Club' }
    team_state
    club_flag_url { 'club_flag_url' }

    initialize_with do
      Club.where(club_name: 'Club').first_or_create
    end
  end
end
