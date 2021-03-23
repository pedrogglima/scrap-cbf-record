# frozen_string_literal: true

RSpec.describe ScrapCbfRecord do
  it 'has a version number' do
    expect(ScrapCbfRecord::VERSION).not_to be nil
  end

  describe 'class methods' do
    describe 'config' do
      it { expect(ScrapCbfRecord.config).to be_a(ScrapCbfRecord::Config) }
    end
  end
end
