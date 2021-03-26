# frozen_string_literal: true

FactoryBot.define do
  factory :round_hash_associations, class: Hash do
    championship { create(:championship) }

    initialize_with do
      new({ championship: championship })
    end
  end

  factory :round_hash_without_associations, class: Hash do
    championship_year

    initialize_with do
      new({ championship: championship_year })
    end
  end
end
