# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::Config::Match do
  let(:klass) { ScrapCbfRecord::Config::Match }
  let(:default_config) do
    {
      class_name: 'Match',
      rename_attrs: {},
      exclude_attrs_on_create: %i[],
      exclude_attrs_on_update: %i[],
      associations: %i[
        championship
        round
        team
      ]
    }
  end

  subject { klass.new }

  describe 'class methods ' do
    describe 'default' do
      it { expect(klass.default).to(eq(default_config)) }
    end
  end

  describe 'initialize' do
    context 'when default <config_attrs>' do
      let(:config) { default_config }

      describe 'class_name' do
        it { expect(subject.class_name).to eq(config[:class_name]) }
      end

      describe 'rename_attrs' do
        it { expect(subject.rename_attrs).to eq(config[:rename_attrs]) }
      end

      describe 'exclude_attrs_on_create' do
        it do
          expect(subject.exclude_attrs_on_create).to eq(
            config[:exclude_attrs_on_create]
          )
        end
      end
      describe 'exclude_attrs_on_update' do
        it do
          expect(subject.exclude_attrs_on_update).to eq(
            config[:exclude_attrs_on_update]
          )
        end
      end

      describe 'associations' do
        it { expect(subject.associations).to eq(config[:associations]) }
      end

      describe 'constant' do
        it { expect(subject.constant).to be(Match) }
      end

      describe 'championship_assoc?' do
        it { expect(subject.championship_assoc?).to be(true) }
      end

      describe 'round_assoc?' do
        it { expect(subject.round_assoc?).to be(true) }
      end

      describe 'team_assoc?' do
        it { expect(subject.team_assoc?).to be(true) }
      end
    end
  end

  describe 'config=' do
    let(:config) { attributes_for(:match_config, class_name: 'Game') }

    it { expect { subject.config = config }.to_not raise_error }

    context 'when custom <config_attrs>' do
      before do
        subject.config = config
      end

      describe 'class_name' do
        it { expect(subject.class_name).to eq(config[:class_name]) }
      end

      describe 'rename_attrs' do
        it { expect(subject.rename_attrs).to eq(config[:rename_attrs]) }
      end

      describe 'exclude_attrs_on_create' do
        it do
          expect(subject.exclude_attrs_on_create).to eq(
            config[:exclude_attrs_on_create]
          )
        end
      end
      describe 'exclude_attrs_on_update' do
        it do
          expect(subject.exclude_attrs_on_update).to eq(
            config[:exclude_attrs_on_update]
          )
        end
      end

      describe 'associations' do
        it { expect(subject.associations).to eq(config[:associations]) }
      end

      describe 'constant' do
        let!(:custom_class_name) { class Game; end }

        it { expect(subject.constant).to be(Game) }
      end

      describe 'championship_assoc?' do
        it { expect(subject.championship_assoc?).to be(true) }
      end

      describe 'round_assoc?' do
        it { expect(subject.round_assoc?).to be(true) }
      end

      describe 'team_assoc?' do
        it { expect(subject.team_assoc?).to be(true) }
      end
    end
  end
end
