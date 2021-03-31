# frozen_string_literal: true

FactoryBot.define do
  factory :championships_attrs, class: Array do
    initialize_with do
      %i[year division]
    end
  end
end
