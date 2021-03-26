# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::Config::Base do
  let(:klass) { ScrapCbfRecord::Config::Base }

  subject { klass.new }

  describe 'class methods ' do
    describe 'default' do
      it { expect { klass.default }.to raise_error(NotImplementedError) }
    end
    describe 'default_<config_attr>' do
      it do
        expect do
          klass.default_class_name
        end.to raise_error(NotImplementedError)
      end

      it do
        expect do
          klass.default_rename_attrs
        end.to raise_error(NotImplementedError)
      end

      it do
        expect do
          klass.default_exclude_attrs_on_create
        end.to raise_error(NotImplementedError)
      end

      it do
        expect do
          klass.default_exclude_attrs_on_update
        end.to raise_error(NotImplementedError)
      end

      it do
        expect do
          klass.default_associations
        end.to raise_error(NotImplementedError)
      end
    end

    describe 'required_<configs_attrs>' do
      it do
        expect do
          klass.must_exclude_attrs
        end.to raise_error(NotImplementedError)
      end
    end
  end
end
