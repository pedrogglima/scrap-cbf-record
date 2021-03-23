# frozen_string_literal: true

FactoryBot.define do
  factory :round, class: Round do
    association :championship
    number { 1 }
  end
end
