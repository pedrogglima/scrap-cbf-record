# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::TagLogger do
  subject { ScrapCbfRecord::TagLogger }

  describe 'logger=' do
    before do
      class CustomLogger; end
      ScrapCbfRecord::TagLogger.logger = CustomLogger
    end

    it { expect(subject.logger).to be(CustomLogger) }
  end

  describe 'logger' do
    context 'with default' do
      before do
        ScrapCbfRecord::TagLogger.logger = nil
      end

      it { expect(subject.logger).to be_a(::Logger) }
      it do
        expect(
          ActiveSupport::Logger.logger_outputs_to?(subject.logger, STDOUT)
        ).to eq(true)
      end
    end
  end

  describe 'with_context' do
    before do
      ScrapCbfRecord::TagLogger.logger = nil
    end

    it { expect(subject.with_context(['tag'], 'message')).to eq(true) }
  end
end
