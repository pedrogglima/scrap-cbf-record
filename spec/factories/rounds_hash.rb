# frozen_string_literal: true

FactoryBot.define do
  factory :round_hash, class: Hash do
    number { 1 }
    matches do
      [
        attributes_for(:match_hash)
      ]
    end
    
    initialize_with { 
      new({
        number: number,
        matches: matches
      }) 
    }
  end
end
