# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Rounds do
  let(:championship) { create(:championship) }
  let(:round) { create(:round, championship_id: championship.id) }

  let(:championship_hash) { attributes_for(:championship_hash) }
  let(:round_hash) { attributes_for(:round_hash) }
  let(:array_rounds) { [round_hash] }

  subject { ScrapCbfRecord::ActiveRecord::Rounds.new(array_rounds) }

  describe 'create_unless_found' do
    context 'when not found' do
      before do
        # may need (see databasecleaner gem)
        Round.destroy_all
      end

      it do
        expect do 
          subject.create_unless_found(championship_hash)
        end.to(change { Round.count }.by(1))
      end
    end

    context 'when found' do
      before do
        round
      end

      it do
        expect do 
          subject.create_unless_found(championship_hash)
        end.to(change { Round.count }.by(0))
      end
    end
  end
end
