# frozen_string_literal: true

FactoryBot.define do
  factory :rounds_attrs, class: Array do
    initialize_with do
      %i[
        championship
        serie
        number
        matches
      ]
    end
  end
end
