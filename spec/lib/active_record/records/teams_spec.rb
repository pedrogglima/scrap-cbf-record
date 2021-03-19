# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Teams do
  let!(:record_config) do
    class Championship; end
    class Match; end
    class Ranking; end
    class Round; end
    class Team; end
  end

  let(:teams) do
    [
      {
        name: 'team_1',
        state: 'state_1',
        avatar_url: 'avatar_url_1'
      }
    ]
  end

  let(:team_hash) { teams.first }

  subject { ScrapCbfRecord::ActiveRecord::Teams.new(teams) }

  describe 'create_unless_found' do
    context 'when not found' do
      before do
        allow(Team).to receive(:find_by).and_return(nil)
      end

      it do
        expect(Team).to receive(:create).with(team_hash)
        subject.create_unless_found
      end
    end

    context 'when found' do
      before do
        allow(Team).to receive(:find_by).and_return(true)
        allow(Team).to receive(:create)
      end

      it do
        expect(Team).to_not receive(:create)
        subject.create_unless_found
      end
    end
  end
end
