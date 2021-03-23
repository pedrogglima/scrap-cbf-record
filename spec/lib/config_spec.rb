# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::Config do
  subject { ScrapCbfRecord::Config.new }

  before do
    # when you want to use a different name than the default classes
    class CustomClassName; end 
  end

  let(:championship) { 'Championship' }
  let(:match) { 'Match' }
  let(:ranking) { 'Ranking' }
  let(:round) { 'Round' }
  let(:team) { 'Team' }
  let(:custom_name) { 'CustomClassName' }

  let(:championship_const) { Object.const_get(championship) }
  let(:match_const) { Object.const_get(match) }
  let(:ranking_const) { Object.const_get(ranking) }
  let(:round_const) { Object.const_get(round) }
  let(:team_const) { Object.const_get(team) }
  let(:custom_name_const) { Object.const_get(custom_name) }

  describe 'initialize' do
    it { expect(subject.championship_class).to eq(championship) }
    it { expect(subject.match_class).to eq(match) }
    it { expect(subject.ranking_class).to eq(ranking) }
    it { expect(subject.round_class).to eq(round) }
    it { expect(subject.team_class).to eq(team) }
  end

  describe 'validate' do
    let(:config) do
      subject.championship_class = championship
      subject.match_class = match
      subject.ranking_class = ranking
      subject.round_class = round
      subject.team_class = team

      subject
    end

    it { expect { config.validate }.to_not raise_error }

    context 'when a different class name is set' do
      let(:config) do
        subject.team_class = custom_name
        subject
      end

      before do
        custom_name_const
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
    it { expect(subject.championship_const).to be(championship_const) }
    it { expect(subject.match_const).to be(match_const) }
    it { expect(subject.ranking_const).to be(ranking_const) }
    it { expect(subject.round_const).to be(round_const) }
    it { expect(subject.team_const).to be(team_const) }

    context 'when a different class name is set' do
      let(:config) do
        subject.team_class = custom_name
        subject
      end

      it { expect(config.team_const).to be(custom_name_const) }
    end
  end

  describe 'record_classes' do
    it { expect(subject.record_classes).to be_a(Array) }
    it { expect(subject.record_classes).to_not include(nil) }
    it { expect(subject.record_classes.length).to eq(5) }
  end
end
