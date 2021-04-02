# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::Config::Ranking do
  let(:klass) { ScrapCbfRecord::Config::Ranking }
  let(:model_class) {  ScrapCbfRecord::Ranking }
  let(:default_config) do
    {
      class_name: 'Ranking',
      rename_attrs: {},
      exclude_attrs_on_create: %i[serie],
      exclude_attrs_on_update: %i[serie],
      associations: {
        championship: {
          class_name: 'Championship',
          foreign_key: :championship_id
        },
        team: {
          class_name: 'Team',
          foreign_key: :team_id
        },
        next_opponent: {
          class_name: 'Team',
          foreign_key: :next_opponent_id
        }
      }
    }
  end

  let(:required) do
    {
      must_exclude_attrs: %i[]
    }
  end

  let(:record_attrs) { build(:rankings_attrs) }

  subject { klass.new }

  describe 'class methods ' do
    describe 'default' do
      it { expect(klass.default).to(eq(default_config)) }
    end

    describe 'record_attrs' do
      it { expect(klass.record_attrs).to(eq(record_attrs)) }
    end
  end

  describe 'initialize' do
    describe 'model' do
      it { expect(subject.model).to be(model_class) }
    end

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

      describe 'klass' do
        it { expect(subject.klass).to be(Ranking) }
      end

      describe 'record_is_a?' do
        it { expect(subject.record_is_a?(:ranking)).to be(true) }
        it { expect(subject.record_is_a?(:another_class)).to be(false) }
      end

      describe 'championship_associate?' do
        it { expect(subject.championship_associate?).to be(true) }
      end

      describe 'team_associate?' do
        it { expect(subject.team_associate?).to be(true) }
      end

      describe 'next_opponent_associate?' do
        it { expect(subject.team_associate?).to be(true) }
      end

      describe 'associations?' do
        it { expect(subject.association?).to be(true) }
      end

      describe 'must_exclude_attrs' do
        it do
          expect(subject.must_exclude_attrs).to eq(
            required[:must_exclude_attrs]
          )
        end
      end
    end
  end

  describe 'config=' do
    let(:config) { attributes_for(:ranking_config, class_name: 'TableRow') }

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

      describe 'klass' do
        let!(:custom_class_name) { class TableRow; end }

        it { expect(subject.klass).to be(TableRow) }
      end

      describe 'championship_associate?' do
        it { expect(subject.championship_associate?).to be(true) }
      end

      describe 'team_associate?' do
        it { expect(subject.team_associate?).to be(true) }
      end

      describe 'next_opponent_associate?' do
        it { expect(subject.team_associate?).to be(true) }
      end
    end
  end

  describe 'record_attrs' do
    it { expect(subject.record_attrs).to(eq(record_attrs)) }
  end

  describe 'exclude_attrs' do
    let(:config) { default_config }

    let(:exclude_attrs) do
      (
        config[:exclude_attrs_on_create] &
        config[:exclude_attrs_on_update]
      ) +
        required[:must_exclude_attrs] +
        config[:associations].keys
    end

    it do
      expect(subject.exclude_attrs).to eq(exclude_attrs)
    end
  end
end
