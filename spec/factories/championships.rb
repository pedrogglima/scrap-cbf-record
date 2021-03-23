# frozen_string_literal: true

FactoryBot.define do
  factory :championship, class: Championship do
    year { 2020 }

    initialize_with do
      Championship.where(year: 2020).first_or_create
    end
  end
end
