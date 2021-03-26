# frozen_string_literal: true

FactoryBot.define do
  factory :ranking_hash, class: Hash do
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

    initialize_with do
      new({
            championship: championship_year,
            serie: championship_serie,
            team: ranking_team,
            next_opponent: ranking_next_opponent,
            posicao: ranking_posicao,
            pontos: ranking_pontos,
            jogos: ranking_jogos,
            vitorias: ranking_vitorias,
            empates: ranking_empates,
            derrotas: ranking_derrotas,
            gols_pro: ranking_gols_contra,
            gols_contra: ranking_gols_contra,
            saldo_de_gols: ranking_saldo_de_gols,
            cartoes_amarelos: ranking_cartoes_amarelos,
            cartoes_vermelhos: ranking_cartoes_vermelhos,
            aproveitamento: ranking_aproveitamento,
            recentes: ranking_recentes
          })
    end
  end
end
