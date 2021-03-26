# frozen_string_literal: true

FactoryBot.define do
  factory :ranking_hash_normalized, class: Hash do
    cup_id { create(:championship).id }
    team_id { create(:team).id }
    next_opponent_id { create(:team_opponent).id }
    ranking_rank
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
            cup_id: cup_id,
            team_id: team_id,
            next_opponent_id: next_opponent_id,
            rank: ranking_rank,
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

  factory :ranking_hash_normalized_without_association, class: Hash do
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
