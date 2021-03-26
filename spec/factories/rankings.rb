# frozen_string_literal: true

FactoryBot.define do
  trait :ranking_posicao do
    posicao { 1 }
  end

  trait :ranking_rank do
    rank { 1 }
  end

  trait :ranking_pontos do
    pontos { 10 }
  end

  trait :ranking_jogos do
    jogos { 10 }
  end

  trait :ranking_vitorias do
    vitorias { 10 }
  end

  trait :ranking_empates do
    empates { 10 }
  end

  trait :ranking_derrotas do
    derrotas { 10 }
  end

  trait :ranking_gols_pro do
    gols_pro { 10 }
  end

  trait :ranking_gols_contra do
    gols_contra { 10 }
  end

  trait :ranking_saldo_de_gols do
    saldo_de_gols { 10 }
  end

  trait :ranking_cartoes_amarelos do
    cartoes_amarelos { 10 }
  end

  trait :ranking_cartoes_vermelhos do
    cartoes_vermelhos { 10 }
  end

  trait :ranking_aproveitamento do
    aproveitamento { 10 }
  end

  trait :ranking_recentes do
    recentes { 'VVV' }
  end

  trait :ranking_team do
    team { attributes_for(:team)[:name] }
  end

  trait :ranking_next_opponent do
    next_opponent { attributes_for(:team_opponent)[:name] }
  end

  #
  ##################################################################
  #

  factory :ranking, class: Ranking do
    association :championship
    association :team
    association :next_opponent, factory: :team_opponent
    ranking_posicao
    ranking_pontos
    ranking_jogos
    ranking_vitorias
    ranking_empates
    ranking_derrotas
    ranking_gols_pro
    ranking_gols_contra
    ranking_saldo_de_gols
    ranking_cartoes_amarelos
    ranking_cartoes_vermelhos
    ranking_aproveitamento
    ranking_recentes
  end

  factory :ranking_renamed_table_row, class: TableRow do
    association :cup, factory: :championship
    association :rank_team, factory: :team
    association :next_team_opponent, factory: :team_opponent
    ranking_rank
    ranking_pontos
    ranking_jogos
    ranking_vitorias
    ranking_empates
    ranking_derrotas
    ranking_aproveitamento
    ranking_recentes
  end

  factory :ranking_without_association, class: RankingWithoutAssociation do
    championship_year
    championship_serie
    ranking_team
    ranking_next_opponent
    ranking_posicao
    ranking_pontos
    ranking_jogos
    ranking_vitorias
    ranking_empates
    ranking_derrotas
    ranking_gols_pro
    ranking_gols_contra
    ranking_saldo_de_gols
    ranking_cartoes_amarelos
    ranking_cartoes_vermelhos
    ranking_aproveitamento
    ranking_recentes
  end
end
