# frozen_string_literal: true

FactoryBot.define do
  factory :team_hash_normalized, class: Hash do
    club_name { attributes_for(:team_hash)[:name] }
    club_flag_url { attributes_for(:team_hash)[:avatar_url] }

    initialize_with do
      new(
        club_name: club_name,
        club_flag_url: club_flag_url
      )
    end
  end
end
