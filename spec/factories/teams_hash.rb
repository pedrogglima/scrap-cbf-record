# frozen_string_literal: true
class TeamHash
  attr_accessor :name,
                :state,
                :avatar_url 
end

FactoryBot.define do
  factory :team_hash, class: TeamHash do
    name { attributes_for(:team)[:name] }
    state { 'state_1' }
    avatar_url { 'avatar_url_1' }
    
    initialize_with { 
      new(
        name: name,
        state: state,
        avatar_url: avatar_url
      ) 
    }
  end
end

FactoryBot.define do
  factory :team_opponent_hash, class: TeamHash do
    name { attributes_for(:team_opponent)[:name] }
    state { 'state_1' }
    avatar_url { 'avatar_url_1' }
    
    initialize_with { 
      new(
        name: name,
        state: state,
        avatar_url: avatar_url
      ) 
    }
  end
end
