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

    initialize_with do
      new({
            number: round_number,
            championship: championship_year,
            serie: championship_serie,
            matches: matches
          })
    end
  end
end
