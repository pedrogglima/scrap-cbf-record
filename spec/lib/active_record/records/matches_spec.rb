# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Matches do
  let!(:record_config) do
    class Championship
      attr_reader :id, :year
      def initialize
        @id = 1
        @year = 2020
      end

      def self.find_by(_attr)
        new
      end
    end

    class Ranking; end
    class Match; end

    class Round
      attr_reader :id, :number
      def initialize
        @id = 1
        @number = '1'
      end

      def self.find_by(_attr)
        new
      end
    end

    class Team
      attr_reader :id, :name
      def initialize
        @id = 1
        @name = 'Team Name'
      end

      def self.find_by(_attr)
        new
      end
    end
  end

  let(:matches_hash) do
    [
      {
        round: '1',
        team: 'Team 1',
        opponent: 'Team 1',
        id_match: '1',
        team_score: '1',
        opponent_score: '1',
        updates: '1',
        date: '12/03/2020 18:00',
        start_at: '18:00',
        place: 'Stadium Test'
      }
    ]
  end

  let(:match_hash_on_create) do
    {
      championship_id: Championship.new.id,
      round_id: Round.new.id,
      team_id: Team.new.id,
      opponent_id: Team.new.id,
      id_match: '1',
      team_score: '1',
      opponent_score: '1',
      updates: '1',
      date: '12/03/2020 18:00',
      start_at: '18:00',
      place: 'Stadium Test'
    }
  end

  let(:match_hash_on_update) do
    {
      team_score: '1',
      opponent_score: '1',
      updates: '1',
      date: '12/03/2020 18:00',
      start_at: '18:00',
      place: 'Stadium Test'
    }
  end

  let(:championship_instance) { Championship.new }
  let(:match_instance) { Match.new }

  subject { ScrapCbfRecord::ActiveRecord::Matches.new(matches_hash) }

  describe 'create_or_update' do
    context 'with there aren\'t matches' do
      before do
        allow(Match).to receive(:find_by).and_return(nil)
      end

      it do
        expect(Match).to receive(:create).with(match_hash_on_create)
        subject.create_or_update(championship_instance)
      end
    end

    context 'with there are matches' do
      before do
        allow(Match).to receive(:find_by).and_return(match_instance)
      end

      it do
        expect(match_instance).to(
          receive(:update).with(match_hash_on_update)
        )
        subject.create_or_update(championship_instance)
      end
    end
  end
end
