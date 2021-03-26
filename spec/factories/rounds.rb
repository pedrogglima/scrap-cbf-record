# frozen_string_literal: true

FactoryBot.define do
  trait :championship_association do
    championship_id { create(:championship).id }
  end

  trait :round_number do
    number { 1 }
  end

  trait :round_identifier do
    identifier { 1 }
  end

  #
  ##################################################################
  #

  factory :round, class: Round do
    championship_association
    round_number

    initialize_with do
      round = Round.where(number: 1).first

      round || new(number: 1, championship_id: championship_id)
    end
  end

  factory :round_renamed_serie, class: Serie do
    association :cup, factory: :championship
    round_identifier
  end

  factory :round_without_association, class: RoundWithoutAssociation do
    championship_year
    championship_division
    round_number
  end
end
