# frozen_string_literal: true

ActiveRecord::Schema.define do
  #########################################
  #
  # RECORD CHAMPIONSHIP
  #
  #########################################
  create_table :championships, force: true do |t|
    t.integer 'year', null: false
    t.string 'serie'

    t.timestamps
  end

  create_table :cups, force: true do |t|
    t.integer 'year', null: false
    t.string 'serie', null: false

    t.timestamps
  end

  #########################################
  #
  # RECORD MATCH
  #
  #########################################
  create_table :matches, force: true do |t|
    t.bigint 'championship_id', null: false
    t.bigint 'team_id', null: false
    t.bigint 'opponent_id', null: false
    t.bigint 'round_id', null: false
    t.integer 'id_match', null: false
    t.string 'updates', null: false
    t.string 'place', null: false
    t.datetime 'date', null: false
    t.string 'start_at', null: false
    t.integer 'team_score', null: false
    t.integer 'opponent_score', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false

    t.timestamps
  end

  create_table :games, force: true do |t|
    t.bigint 'cup_id', null: false
    t.bigint 'match_team_id', null: false
    t.bigint 'team_opponent_id', null: false
    t.bigint 'match_round_id', null: false
    t.integer 'identifier', null: false
    t.string 'place', null: false
    t.datetime 'date', null: false
    t.string 'start_at', null: false
    t.integer 'team_score', null: false
    t.integer 'opponent_score', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false

    t.timestamps
  end

  create_table :match_without_associations, force: true do |t|
    t.bigint 'championship', null: false
    t.bigint 'serie', null: false
    t.bigint 'team', null: false
    t.bigint 'opponent', null: false
    t.bigint 'round', null: false
    t.integer 'id_match', null: false
    t.string 'updates', null: false
    t.string 'place', null: false
    t.datetime 'date', null: false
    t.string 'start_at', null: false
    t.integer 'team_score', null: false
    t.integer 'opponent_score', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false

    t.timestamps
  end

  #########################################
  #
  # RECORD RANKING
  #
  #########################################
  create_table :rankings, force: true do |t|
    t.bigint 'championship_id', null: false
    t.bigint 'team_id', null: false
    t.bigint 'next_opponent_id'
    t.integer 'posicao', null: false
    t.integer 'pontos', null: false
    t.integer 'jogos', null: false
    t.integer 'vitorias', null: false
    t.integer 'empates', null: false
    t.integer 'derrotas', null: false
    t.integer 'gols_pro', null: false
    t.integer 'gols_contra', null: false
    t.integer 'saldo_de_gols', null: false
    t.integer 'cartoes_amarelos', null: false
    t.integer 'cartoes_vermelhos', null: false
    t.integer 'aproveitamento', null: false
    t.string 'recentes', null: false

    t.timestamps
  end

  create_table :table_rows, force: true do |t|
    t.bigint 'cup_id', null: false
    t.bigint 'rank_team_id', null: false
    t.bigint 'next_team_opponent_id'
    t.integer 'rank', null: false
    t.integer 'pontos', null: false
    t.integer 'jogos', null: false
    t.integer 'vitorias', null: false
    t.integer 'empates', null: false
    t.integer 'derrotas', null: false
    t.integer 'aproveitamento', null: false
    t.string 'recentes', null: false

    t.timestamps
  end

  create_table :ranking_without_associations, force: true do |t|
    t.bigint 'championship', null: false
    t.string 'serie', null: false
    t.bigint 'team', null: false
    t.bigint 'next_opponent'
    t.integer 'posicao', null: false
    t.integer 'pontos', null: false
    t.integer 'jogos', null: false
    t.integer 'vitorias', null: false
    t.integer 'empates', null: false
    t.integer 'derrotas', null: false
    t.integer 'gols_pro', null: false
    t.integer 'gols_contra', null: false
    t.integer 'saldo_de_gols', null: false
    t.integer 'cartoes_amarelos', null: false
    t.integer 'cartoes_vermelhos', null: false
    t.integer 'aproveitamento', null: false
    t.string 'recentes', null: false

    t.timestamps
  end

  #########################################
  #
  # RECORD ROUND
  #
  #########################################
  create_table :rounds, force: true do |t|
    t.bigint 'championship_id', null: false
    t.integer 'number', null: false

    t.timestamps
  end

  create_table :series, force: true do |t|
    t.bigint 'cup_id', null: false
    t.integer 'identifier', null: false

    t.timestamps
  end

  create_table :round_without_associations, force: true do |t|
    t.bigint 'championship', null: false
    t.string 'division', null: false
    t.integer 'number', null: false

    t.timestamps
  end

  #########################################
  #
  # RECORD TEAM
  #
  #########################################
  create_table :teams, force: true do |t|
    t.string 'name', null: false
    t.string 'state', null: false
    t.string 'avatar_url', null: false

    t.timestamps
  end

  create_table :clubs, force: true do |t|
    t.string 'club_name', null: false
    t.string 'state'
    t.string 'club_flag_url', null: false

    t.timestamps
  end
end
