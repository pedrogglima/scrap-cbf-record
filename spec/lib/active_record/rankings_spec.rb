# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Rankings do
  let(:championship) { create(:championship) }
  let(:team) { create(:team) }
  let(:next_opponent) { create(:team_opponent) }

  let(:championship_hash) { attributes_for(:championship_hash) }
  
  describe 'create_or_update' do
    context 'when there aren\'t rankings' do
      let(:ranking_hash) { attributes_for(:ranking_hash) }
      let(:array_rankings) { [ranking_hash] }

      subject do
        ScrapCbfRecord::ActiveRecord::Rankings.new(array_rankings) 
      end
      
      before do
        championship
        team
        next_opponent
        Ranking.destroy_all
      end

      it do
        expect do 
          subject.create_or_update(championship_hash)
        end.to(change { Ranking.count }.by(1))
      end
    end

    context 'when there are rankings' do
      let(:ranking_hash) do
        attributes_for(:ranking_hash, pontos: 20) 
      end
      let(:array_rankings) { [ranking_hash] }

      subject do 
        ScrapCbfRecord::ActiveRecord::Rankings.new(array_rankings)
      end

      before do
        championship
        team
        next_opponent
        create(
          :ranking, 
          championship_id: championship.id, 
          team_id: team.id,
          next_opponent_id: next_opponent.id,
          pontos: 20
        )
      end

      it "expect to update attribute" do
        subject.create_or_update(championship_hash)
        ranking = Ranking.find_by(posicao: 1)
        expect(ranking.reload.pontos).to(eq(20))
      end
    end
  end
end
