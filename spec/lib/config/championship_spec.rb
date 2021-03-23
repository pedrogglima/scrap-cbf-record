# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::Config::Championship do
  let(:custom_name) { 'CustomClassName' }
  let(:championship_class) { Championship }
  let(:championship_config) { attributes_for(:championship_config) }
  let(:klass) { ScrapCbfRecord::Config::Championship }

  let(:default_config) do
    {
      class_name: 'Championship',
      rename_attrs: {},
      exclude_attrs: {},
      associations: %i[]
    }
  end

  before do
    # when you want to use a different name than the default classes
    class CustomClassName; end
  end

  subject { klass.new(championship_config) }

  describe 'class methods ' do
    describe 'default' do
      it { expect(klass.default).to(eq(default_config)) }
    end
  end

  describe 'initialize' do
    context 'when pass' do
      context 'a defined class_name' do
        it { expect { subject }.to_not raise_error }
      end

      context 'an undefined class_name' do
        let(:championship_config) do
          attributes_for(:championship_config, class_name: 'Undefined')
        end

        it { expect { subject }.to raise_error(NameError) }
      end

      context 'an invalid type for class_name' do
        let(:championship_config) do
          attributes_for(:championship_config, class_name: 12_345)
        end

        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end
  end

  describe 'constant' do
    it { expect(subject.constant).to(eq(championship_class)) }
  end
end
