# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Teams do
  let(:team) { create(:team) }
  let(:team_hash) { attributes_for(:team_hash) }
  let(:array_teams) { [team_hash] }

  subject { ScrapCbfRecord::ActiveRecord::Teams.new(array_teams) }

  describe 'create_unless_found' do
    context 'when not found' do
      before do
        # may need (see databasecleaner gem)
        Team.destroy_all
      end

      it do
        expect do 
          subject.create_unless_found
        end.to(change { Team.count }.by(1))
      end
    end

    context 'when found' do
      before do
        team
      end

      it do
        expect do 
          subject.create_unless_found
        end.to(change { Team.count }.by(0))
      end
    end
  end
end
