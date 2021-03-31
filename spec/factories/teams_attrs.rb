# frozen_string_literal: true

FactoryBot.define do
  factory :teams_attrs, class: Array do
    initialize_with do
      %i[
        name
        state
        avatar_url
      ]
    end
  end
end
