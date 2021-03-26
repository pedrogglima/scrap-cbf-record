# frozen_string_literal: true

FactoryBot.define do
  factory :round_config, class: Hash do
    class_name { 'Round' }
    rename_attrs do
      {}
    end
    exclude_attrs_on_create do
      %i[]
    end
    exclude_attrs_on_update do
      %i[]
    end
    associations do
      {
        championship: {
          class_name: 'Championship',
          foreign_key: :championship_id
        }
      }
    end

    initialize_with do
      new({
            class_name: class_name,
            rename_attrs: rename_attrs,
            exclude_attrs_on_create: exclude_attrs_on_create,
            exclude_attrs_on_update: exclude_attrs_on_update,
            associations: associations
          })
    end
  end
end
