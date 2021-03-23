# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Matches do
  let(:championship) { create(:championship) }
  let(:round) { create(:round, championship_id: championship.id) }
  let(:team) { create(:team) }
  let(:opponent) { create(:team_opponent) }

  let(:championship_hash) { attributes_for(:championship_hash) }

  describe 'create_or_update' do
    context 'when there aren\'t matches' do
      let(:match_hash) { attributes_for(:match_hash) }
      let(:array_matches) { [match_hash] }

      subject do
        ScrapCbfRecord::ActiveRecord::Matches.new(array_matches)
      end

      before do
        championship
        team
        opponent
        round
        Match.destroy_all
      end

      it do
        expect do
          subject.create_or_update(championship_hash)
        end.to(change { Match.count }.by(1))
      end
    end

    context 'when there are matches' do
      let(:match_hash) do
        attributes_for(:match_hash, team_score: 2, opponent_score: 2) 
      end
      let(:array_matches) { [match_hash] }

      subject do
        ScrapCbfRecord::ActiveRecord::Matches.new(array_matches)
      end

      before do
        championship
        team
        opponent
        round

        create(
          :match, 
          championship_id: championship.id, 
          round_id: round.id,
          team_id: team.id,
          opponent_id: opponent.id,
          team_score: '2',
          opponent_score: '2'
        )
      end

      it "expect to update attribute" do
          subject.create_or_update(championship_hash)
          match = Match.find_by(id_match: 1)
          expect(match.reload.team_score).to(eq(2))
          expect(match.reload.opponent_score).to(eq(2))
      end
    end
  end
end
