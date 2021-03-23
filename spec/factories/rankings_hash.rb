# frozen_string_literal: true

FactoryBot.define do
  factory :ranking_hash, class: Hash do
    team { create(:team).name }
    next_opponent { create(:team_opponent).name }
    posicao { 1 }
    pontos { 10 }
    jogos { 10 }
    vitorias { 10 }
    empates { 10 }
    derrotas { 10 }
    gols_pro { 10 }
    gols_contra { 10 }
    saldo_de_gols { 10 }
    cartoes_amarelos { 10 }
    cartoes_vermelhos { 10 }
    aproveitamento { 10 }
    recentes { 'VVV' }

    initialize_with {
      new({
        team: team,
        next_opponent: next_opponent,
        posicao: posicao,
        pontos: pontos,
        jogos: jogos,
        vitorias: vitorias,
        empates: empates,
        derrotas: derrotas,
        gols_pro: gols_contra,
        gols_contra: gols_contra,
        saldo_de_gols: saldo_de_gols,
        cartoes_amarelos: cartoes_amarelos,
        cartoes_vermelhos: cartoes_vermelhos,
        aproveitamento: aproveitamento,
        recentes: recentes
      })
    }
  end
end
