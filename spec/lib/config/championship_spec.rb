# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::Config::Championship do
  let(:klass) { ScrapCbfRecord::Config::Championship }
  let(:default_config) do
    {
      class_name: 'Championship',
      rename_attrs: {},
      exclude_attrs_on_create: %i[],
      exclude_attrs_on_update: %i[],
      associations: %i[]
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
        it { expect(subject.constant).to be(Championship) }
      end

      describe 'championship_assoc?' do
        it { expect(subject.championship_assoc?).to be(false) }
      end

      describe 'round_assoc?' do
        it { expect(subject.round_assoc?).to be(false) }
      end

      describe 'team_assoc?' do
        it { expect(subject.team_assoc?).to be(false) }
      end
    end
  end

  describe 'config=' do
    let(:config) { attributes_for(:championship_config, class_name: 'Cup') }

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
        let!(:custom_class_name) { class Cup; end }

        it { expect(subject.constant).to be(Cup) }
      end

      describe 'championship_assoc?' do
        it { expect(subject.championship_assoc?).to be(false) }
      end

      describe 'round_assoc?' do
        it { expect(subject.round_assoc?).to be(false) }
      end

      describe 'team_assoc?' do
        it { expect(subject.team_assoc?).to be(false) }
      end
    end
  end
end
