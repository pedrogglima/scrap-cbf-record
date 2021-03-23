# frozen_string_literal: true

FactoryBot.define do
  factory :match, class: Match do
    association :championship
    association :team
    association :opponent, factory: :team_opponent
    association :round

    id_match { 1 }
    team_score { 1 }
    opponent_score { 1 }
    updates { 1 }
    date { '12/03/2020 18:00' }
    start_at { '18:00' }
    place { 'Stadium Test' }
  end
end
