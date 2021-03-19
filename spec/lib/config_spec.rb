# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::Config do
  subject { ScrapCbfRecord::Config.new }

  describe 'initialize' do
    it { expect(subject.championship_class).to eq('Championship') }
    it { expect(subject.match_class).to eq('Match') }
    it { expect(subject.ranking_class).to eq('Ranking') }
    it { expect(subject.round_class).to eq('Round') }
    it { expect(subject.team_class).to eq('Team') }
  end

  describe 'validate' do
    let(:config) do
      subject.championship_class = 'Championship'
      subject.match_class = 'Match'
      subject.ranking_class = 'Ranking'
      subject.round_class = 'Round'
      subject.team_class = 'Team'

      subject
    end

    before do
      class Championship; end
      class Match; end
      class Ranking; end
      class Round; end
      class Team; end
    end

    it { expect { config.validate }.to_not raise_error }

    context 'when only some constants are present' do
      let(:config) do
        subject.match_class = 'Match'
        subject.team_class = 'Team'
        subject
      end

      before do
        class Match; end
        class Team; end
      end

      it { expect { config.validate }.to_not raise_error }
    end

    context 'when a different class name is set' do
      let(:config) do
        subject.team_class = 'Club'
        subject
      end

      before do
        class Club; end
      end

      it { expect { config.validate }.to_not raise_error }
    end

    context 'when is a invalid type input' do
      let(:config) do
        subject.match_class = 12_345.50
        subject
      end

      it { expect { config.validate }.to raise_error(::ArgumentError) }
    end

    context 'when const is not defined' do
      let(:config) do
        subject.match_class = 'ClassNotDeclared'
        subject
      end

      it { expect { config.validate }.to raise_error(::NameError) }
    end
  end

  describe '<class>_const' do
    before do
      class Championship; end
      class Match; end
      class Ranking; end
      class Round; end
      class Team; end
    end

    it { expect(subject.championship_const).to be(Championship) }
    it { expect(subject.match_const).to be(Match) }
    it { expect(subject.ranking_const).to be(Ranking) }
    it { expect(subject.round_const).to be(Round) }
    it { expect(subject.team_const).to be(Team) }

    context 'when a different class name is set' do
      let(:config) do
        subject.team_class = 'Club'
        subject
      end

      before do
        class Club; end
      end

      it { expect(config.team_const).to be(Club) }
    end
  end

  describe 'record_classes' do
    before do
      class Championship; end
      class Match; end
      class Ranking; end
      class Round; end
      class Team; end
    end

    it { expect(subject.record_classes).to be_a(Array) }
    it { expect(subject.record_classes).to_not include(nil) }
    it { expect(subject.record_classes.length).to eq(5) }
  end
end
