# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Rounds do
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
    class Team; end
  end

  let(:rounds_hash) do
    [
      {
        number: '1',
        matches: [{ id_match: '1' }, { id_match: '2' }]
      }
    ]
  end

  let(:round_hash_on_create) do
    {
      number: '1',
      championship_id: Championship.new.id
    }
  end

  let(:championship_instance) { Championship.new }

  subject { ScrapCbfRecord::ActiveRecord::Rounds.new(rounds_hash) }

  describe 'create_unless_found' do
    context 'when not found' do
      before do
        allow(Round).to receive(:find_round).and_return(nil)
      end

      it do
        expect(Round).to receive(:create).with(round_hash_on_create)
        subject.create_unless_found(championship_instance)
      end
    end

    context 'when found' do
      before do
        allow(Round).to receive(:find_round).and_return(true)
      end

      it do
        expect(Round).to_not receive(:create)
        subject.create_unless_found(championship_instance)
      end
    end
  end
end
