# frozen_string_literal: true

FactoryBot.define do
  trait :ranking_position do
    position { 1 }
  end

  trait :ranking_rank do
    rank { 1 }
  end

  trait :ranking_points do
    points { 10 }
  end

  trait :ranking_played do
    played { 10 }
  end

  trait :ranking_won do
    won { 10 }
  end

  trait :ranking_drawn do
    drawn { 10 }
  end

  trait :ranking_lost do
    lost { 10 }
  end

  trait :ranking_goals_for do
    goals_for { 10 }
  end

  trait :ranking_goals_against do
    goals_against { 10 }
  end

  trait :ranking_goal_difference do
    goal_difference { 10 }
  end

  trait :ranking_yellow_cards do
    yellow_card { 10 }
  end

  trait :ranking_red_cards do
    red_card { 10 }
  end

  trait :ranking_advantages do
    advantages { 10 }
  end

  trait :ranking_form do
    form { 'VVV' }
  end

  trait :ranking_team do
    team { attributes_for(:team)[:name] }
  end

  trait :ranking_next_opponent do
    next_opponent { attributes_for(:team_opponent)[:name] }
  end

  #
  ##################################################################
  #

  factory :ranking, class: Ranking do
    association :championship
    association :team
    association :next_opponent, factory: :team_opponent
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
  end

  factory :ranking_renamed_table_row, class: TableRow do
    association :cup, factory: :championship
    association :rank_team, factory: :team
    association :next_team_opponent, factory: :team_opponent
    ranking_rank
    ranking_points
    ranking_played
    ranking_won
    ranking_drawn
    ranking_lost
    ranking_advantages
    ranking_form
  end

  factory :ranking_without_association, class: RankingWithoutAssociation do
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
  end
end
