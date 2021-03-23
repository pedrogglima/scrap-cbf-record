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
    let(:klass) { ScrapCbfRecord::ActiveRecord }

    describe 'class methods' do
      subject { klass }

      context 'when is valid should return' do
        it { expect(subject.save(records_hash)).to be(true) }
      end
    end

    let(:invalid_records_hash) { { championship: {} } }
    let(:records_json) { records_hash.to_json }
    let(:invalid_records_json) { 'invalid json' }
    let(:invalid_records_type) { 12_345 }

    subject { klass.new(records_hash) }

    describe 'initialize' do
      context 'when argument' do
        context 'is valid' do
          context 'and is a hash' do
            it { expect { klass.new(records_hash) }.to_not raise_error }
          end

          context 'and is a json' do
            it { expect { klass.new(records_json) }.to_not raise_error }
          end
        end

        context 'is invalid' do
          context 'and is a hash' do
            it do
              expect { klass.new(invalid_records_hash) }.to(
                raise_error(ScrapCbfRecord::MissingKeyError)
              )
            end
          end

          context 'and is a json' do
            it do
              expect { klass.new(invalid_records_json) }.to(
                raise_error(ScrapCbfRecord::JsonDecodeError)
              )
            end
          end
        end

        context 'is a invalid type' do
          it do
            expect { klass.new(invalid_records_type) }.to(
              raise_error(::ArgumentError)
            )
          end
        end
      end
    end

    describe 'save' do
      context 'when is valid should return' do
        it { expect(subject.save).to be(true) }
      end
    end
  end
end
