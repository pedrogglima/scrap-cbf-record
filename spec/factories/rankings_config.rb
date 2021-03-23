# frozen_string_literal: true

FactoryBot.define do
  factory :ranking_config, class: Hash do
    class_name { 'Ranking' }
    rename_attrs do
      {
        pontos: :points
      }
    end
    exclude_attrs do
      %i[]
    end
    associations do
      %i[
        championship
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
