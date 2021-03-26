# frozen_string_literal: true

FactoryBot.define do
  factory :championship_hash, class: Hash do
    year { 2020 }
    serie { 'serie-a' }
    initialize_with { new({ year: year }) }
  end
end
