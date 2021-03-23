# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::Config do
  let(:championship_class) { Championship }
  let(:match_class) { Match }
  let(:ranking_class) { Ranking }
  let(:round_class) { Round }
  let(:team_class) { Team }

  let(:championship_config) { ScrapCbfRecord::Config::Championship }
  let(:match_config) { ScrapCbfRecord::Config::Match }
  let(:ranking_config) { ScrapCbfRecord::Config::Ranking }
  let(:round_config) { ScrapCbfRecord::Config::Round }
  let(:team_config) { ScrapCbfRecord::Config::Team }

  subject { ScrapCbfRecord::Config.new }

  describe 'initialize' do
    it { expect(subject.championship).to(be_a(championship_config)) }
    it { expect(subject.match).to(be_a(match_config)) }
    it { expect(subject.ranking).to(be_a(ranking_config)) }
    it { expect(subject.round).to(be_a(round_config)) }
    it { expect(subject.team).to(be_a(team_config)) }
  end

  describe 'record_classes' do
    it { expect(subject.record_classes).to be_a(Array) }
    it { expect(subject.record_classes).to include(championship_class) }
    it { expect(subject.record_classes).to include(match_class) }
    it { expect(subject.record_classes).to include(ranking_class) }
    it { expect(subject.record_classes).to include(round_class) }
    it { expect(subject.record_classes).to include(team_class) }
    it { expect(subject.record_classes.length).to eq(5) }
  end
end
