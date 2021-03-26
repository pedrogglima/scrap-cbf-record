# frozen_string_literal: true

FactoryBot.define do
  trait :championship_year do
    championship { 2020 }
  end

  trait :championship_serie do
    serie { 'serie-a' }
  end

  trait :championship_division do
    division { 'serie-a' }
  end

  factory :championship, class: Championship do
    year { 2020 }
    serie { 'serie-a' }

    initialize_with do
      Championship.where(year: 2020).first_or_create
    end
  end
end
