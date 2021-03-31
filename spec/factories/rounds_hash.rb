# frozen_string_literal: true

FactoryBot.define do
  factory :round_hash, class: Hash do
    round_number
    championship_year
    championship_serie
    matches do
      [
        attributes_for(:match_hash)
      ]
    end
  end

  factory :invalid_round_hash, class: Hash do
    championship_year
    championship_serie
    matches do
      [
        attributes_for(:match_hash)
      ]
    end
  end
end
