# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord do
  describe 'save' do
    let!(:championship) { create(:championship) }
    let(:championship_hash) { attributes_for(:championship_hash) }
    let(:match_hash) { attributes_for(:match_hash) }
    let(:ranking_hash) { attributes_for(:ranking_hash) }
    let(:round_hash) { attributes_for(:round_hash) }
    let(:team_hash) { attributes_for(:team_hash) }

    let(:records_hash) do
      {
        championship: championship_hash,
        matches: [match_hash],
        rankings: [ranking_hash],
        rounds: [round_hash],
        teams: [team_hash]
      }
    end

    let(:record_class) { ScrapCbfRecord::ActiveRecord.save }
    
    subject { ScrapCbfRecord::ActiveRecord.save(records_hash) } 

    context "when is valid should return" do
      it { expect(subject).to be(true) }
    end
  end
end
