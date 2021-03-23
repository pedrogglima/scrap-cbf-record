# frozen_string_literal: true

FactoryBot.define do
  factory :match_config, class: Hash do
    class_name { 'Match' }
    rename_attrs do
      {
        date: :date_match
      }
    end
    exclude_attrs do
      %i[
        start_at
      ]
    end
    associations do
      %i[
        championship
        round
        team
      ]
    end

    initialize_with do
      new({
            class_name: class_name,
            rename_attrs: rename_attrs,
            exclude_attrs: exclude_attrs,
            associations: associations
          })
    end
  end
end
