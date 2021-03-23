# frozen_string_literal: true

FactoryBot.define do
  factory :championship_config, class: Hash do
    class_name { 'Championship' }
    rename_attrs do
      {}
    end
    exclude_attrs do
      %i[]
    end
    associations do
      %i[]
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
