# frozen_string_literal: true

FactoryBot.define do
  factory :round_hash_normalized, class: Hash do
    identifier { attributes_for(:round_hash)[:number] }
    cup_id { create(:championship).id }
    championship_serie

    initialize_with do
      new({
            identifier: identifier,
            cup_id: cup_id,
            serie: championship_serie
          })
    end
  end

  factory :round_hash_normalized_without_association, class: Hash do
    identifier { attributes_for(:round_hash)[:number] }
    championship_year
    championship_serie

    initialize_with do
      new({
            identifier: identifier,
            championship: championship_year,
            serie: championship_serie
          })
    end
  end
end
