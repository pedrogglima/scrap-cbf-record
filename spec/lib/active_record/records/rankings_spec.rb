# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Rankings do
  let!(:record_config) do
    class Championship
      attr_accessor :id, :year
      def initialize
        @id = 1
        @year = 2020
      end

      def self.find_by(_attr)
        new
      end
    end

    class Match; end
    class Ranking; end
    class Round; end

    class Team
      attr_accessor :id, :name
      def initialize
        @id = 1
        @name = 'Team Name'
      end

      def self.find_by(_attr)
        new
      end
    end
  end

  let(:rankings_hash) do
    [
      {
        posicao: '1',
        team: 'Team 1',
        pontos: '10',
        jogos: '10',
        vitorias: '10',
        empates: '10',
        derrotas: '10',
        gols_pro: '10',
        gols_contra: '10',
        saldo_de_gols: '10',
        cartoes_amarelos: '10',
        cartoes_vermelhos: '10',
        aproveitamento: '10',
        recentes: 'VVV',
        next_opponent: 'Team 1'
      }
    ]
  end

  let(:ranking_hash_on_create) do
    {
      posicao: '1',
      championship_id: Championship.new.id,
      team_id: Team.new.id,
      pontos: '10',
      jogos: '10',
      vitorias: '10',
      empates: '10',
      derrotas: '10',
      gols_pro: '10',
      gols_contra: '10',
      saldo_de_gols: '10',
      cartoes_amarelos: '10',
      cartoes_vermelhos: '10',
      aproveitamento: '10',
      recentes: 'VVV',
      next_opponent_id: Team.new.id
    }
  end

  let(:ranking_hash_on_update) do
    {
      team_id: Team.new.id,
      pontos: '10',
      jogos: '10',
      vitorias: '10',
      empates: '10',
      derrotas: '10',
      gols_pro: '10',
      gols_contra: '10',
      saldo_de_gols: '10',
      cartoes_amarelos: '10',
      cartoes_vermelhos: '10',
      aproveitamento: '10',
      recentes: 'VVV',
      next_opponent_id: Team.new.id
    }
  end

  let(:championship_instance) { Championship.new }
  let(:ranking_instance) { Ranking.new }

  subject { ScrapCbfRecord::ActiveRecord::Rankings.new(rankings_hash) }

  describe 'create_or_update' do
    context 'with there aren\'t rankings' do
      before do
        allow(Ranking).to receive(:find_by).and_return(nil)
      end

      it do
        expect(Ranking).to receive(:create).with(ranking_hash_on_create)
        subject.create_or_update(championship_instance)
      end
    end

    context 'with there are rankings' do
      before do
        allow(Ranking).to receive(:find_by).and_return(ranking_instance)
      end

      it do
        expect(ranking_instance).to(
          receive(:update).with(ranking_hash_on_update)
        )
        subject.create_or_update(championship_instance)
      end
    end
  end
end
