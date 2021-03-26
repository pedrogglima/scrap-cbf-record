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

  trait :club_flag_url do
    club_flag_url { 'club_flag_url' }
  end

  #
  ##################################################################
  #

  factory :team, class: Team do
    team_name
    team_state
    team_avatar_url

    initialize_with do
      team = Team.where(name: 'Team').first

      team || new(name: 'Team', state: 'state', avatar_url: 'avatar_url')
    end
  end

  factory :team_opponent, class: Team do
    team_opponent_name
    team_state
    team_avatar_url

    initialize_with do
      team = Team.where(name: 'Team Opponent').first

      team || new(name: 'Team Opponent', state: 'state', avatar_url: 'avatar_url')
    end
  end

  factory :team_renamed_club, class: Club do
    club_name { 'Club' }
    club_flag_url { 'club_flag_url' }

    initialize_with do
      club = Club.where(club_name: 'Club').first

      club || new(club_name: 'Club', club_flag_url: 'club_flag_url')
    end
  end
end
