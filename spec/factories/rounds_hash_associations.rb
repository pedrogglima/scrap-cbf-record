# frozen_string_literal: true

FactoryBot.define do
  factory :round_hash_associations, class: Hash do
    championship { create(:championship) }
  end

  factory :round_hash_without_associations, class: Hash do
    championship_year
  end
end
