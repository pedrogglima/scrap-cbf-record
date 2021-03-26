# frozen_string_literal: true

FactoryBot.define do
  trait :match_id_match do
    id_match { 1 }
  end

  trait :match_identifier do
    identifier { 1 }
  end

  trait :match_team_score do
    team_score { 1 }
  end

  trait :match_opponent_score do
    opponent_score { 1 }
  end

  trait :match_updates do
    updates { 1 }
  end

  trait :match_date do
    date { '12/03/2020 18:00' }
  end

  trait :match_start_at do
    start_at { '18:00' }
  end

  trait :match_place do
    place { 'Stadium Test' }
  end

  trait :match_team do
    team { attributes_for(:team)[:name] }
  end

  trait :match_opponent do
    opponent { attributes_for(:team_opponent)[:name] }
  end

  trait :match_round do
    round { attributes_for(:round)[:number] }
  end

  #
  ##################################################################
  #

  factory :match, class: Match do
    association :championship
    association :team
    association :opponent, factory: :team_opponent
    association :round

    match_id_match
    match_team_score
    match_opponent_score
    match_updates
    match_date
    match_start_at
    match_place
  end

  factory :match_renamed_game, class: Game do
    association :cup, factory: :championship
    association :team
    association :opponent, factory: :team_opponent
    association :round

    match_identifier
    match_team_score
    match_opponent_score
    match_updates
    match_date
    match_start_at
    match_place
  end

  factory :match_without_association, class: MatchWithoutAssociation do
    championship_year
    championship_serie
    match_team
    match_opponent
    match_round
    match_id_match
    match_team_score
    match_opponent_score
    match_updates
    match_date
    match_start_at
    match_place
  end
end
