# frozen_string_literal: true

RSpec.describe ScrapCbfRecord do
  let(:klass) { ScrapCbfRecord }

  it 'has a version number' do
    expect(klass::VERSION).not_to be nil
  end

  describe 'class methods' do
    describe 'config' do
      let(:klass_config) { ScrapCbfRecord::Config }
      subject { klass.config }

      it { expect(subject).to be_a(klass_config) }
      describe '<record> classes' do
        it { expect(subject.championship).to be_a(klass_config::Championship) }
        it { expect(subject.match).to be_a(klass_config::Match) }
        it { expect(subject.ranking).to be_a(klass_config::Ranking) }
        it { expect(subject.round).to be_a(klass_config::Round) }
        it { expect(subject.team).to be_a(klass_config::Team) }

        describe 'default <record> config' do
          let(:configs) { attributes_for(:championship_config) }

          subject { klass.config.championship }

          it { expect(subject.class_name).to eq(configs[:class_name]) }
          it { expect(subject.rename_attrs).to eq(configs[:rename_attrs]) }
          it do
            expect(subject.exclude_attrs_on_create).to eq(
              configs[:exclude_attrs_on_create]
            )
          end
          it do
            expect(subject.exclude_attrs_on_update).to eq(
              configs[:exclude_attrs_on_update]
            )
          end
          it { expect(subject.associations).to eq(configs[:associations]) }
        end
      end
    end

    describe 'settings' do
      it { expect(klass.settings).to be_a(klass::Config) }

      context 'when block is given' do
        let(:configs) do
          attributes_for(:championship_config, class_name: 'Cup')
        end
        subject { klass.config.championship }

        before do
          klass.settings do |config|
            config.championship.config = configs
          end
        end

        it { expect(subject.class_name).to eq(configs[:class_name]) }
        it { expect(subject.rename_attrs).to eq(configs[:rename_attrs]) }
        it do
          expect(subject.exclude_attrs_on_create).to eq(
            configs[:exclude_attrs_on_create]
          )
        end
        it do
          expect(subject.exclude_attrs_on_update).to eq(
            configs[:exclude_attrs_on_update]
          )
        end
        it { expect(subject.associations).to eq(configs[:associations]) }
      end
    end
  end
end
