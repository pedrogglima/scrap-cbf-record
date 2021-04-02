# frozen_string_literal: true

FactoryBot.define do
  factory :round_hash_normalized, class: Hash do
    identifier { attributes_for(:round_hash)[:number] }
    cup_id { create(:championship).id }
  end

  factory :round_hash_normalized_without_association, class: Hash do
    round_number
    championship_year
    championship_division
  end
end
