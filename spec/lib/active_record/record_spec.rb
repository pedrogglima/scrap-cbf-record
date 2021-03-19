# frozen_string_literal: true

require 'json'

RSpec.describe ScrapCbfRecord::ActiveRecord::Record do
  let(:records_hash) do
    {
      championship: {},
      matches: [],
      rankings: [],
      rounds: [],
      teams: []
    }
  end

  let(:invalid_records_hash) { { championship: {} } }

  let(:records_json) { records_hash.to_json }

  let(:invalid_records_json) { 'invalid json' }

  let(:invalid_records_type) { 12_345 }

  let(:record_class) { ScrapCbfRecord::ActiveRecord::Record }

  describe 'initialize' do
    context 'when argument' do
      context 'is valid' do
        context 'and is a hash' do
          it { expect { record_class.new(records_hash) }.to_not raise_error }
        end

        context 'and is a json' do
          it { expect { record_class.new(records_json) }.to_not raise_error }
        end
      end

      context 'is invalid' do
        context 'and is a hash' do
          it do
            expect { record_class.new(invalid_records_hash) }.to(
              raise_error(ScrapCbfRecord::MissingKeyError)
            )
          end
        end

        context 'and is a json' do
          it do
            expect { record_class.new(invalid_records_json) }.to(
              raise_error(ScrapCbfRecord::JsonDecodeError)
            )
          end
        end
      end

      context 'is a invalid type' do
        it do
          expect { record_class.new(invalid_records_type) }.to(
            raise_error(::ArgumentError)
          )
        end
      end
    end
  end

  describe 'save' do
    # This method only offers a interface for others class/method.
    # Those others class/methods were already tested in records/*_spec.rb.
    # Only thing that may be worthy note here is that:
    # The order of callings methods matter here.
    # It must go Teams > (Rankings|Rounds) > Matches
  end
end
