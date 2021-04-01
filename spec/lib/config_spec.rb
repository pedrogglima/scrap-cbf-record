# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::Config do
  let(:championship_class) { Championship }
  let(:match_class) { Match }
  let(:ranking_class) { Ranking }
  let(:round_class) { Round }
  let(:team_class) { Team }

  let(:klass) { ScrapCbfRecord::Config }

  let(:championship_config) { klass::Championship }
  let(:match_config) { klass::Match }
  let(:ranking_config) { klass::Ranking }
  let(:round_config) { klass::Round }
  let(:team_config) { klass::Team }

  describe 'class methods' do
    subject { klass }

    describe 'instance' do
      it { expect(subject.instance).to(be_a(klass)) }
    end

    describe 'new' do
      it { expect { subject.new }.to(raise_error(NoMethodError)) }
    end
  end

  subject { klass.instance }

  describe 'initialize' do
    it { expect(subject.championship).to(be_a(championship_config)) }
    it { expect(subject.match).to(be_a(match_config)) }
    it { expect(subject.ranking).to(be_a(ranking_config)) }
    it { expect(subject.round).to(be_a(round_config)) }
    it { expect(subject.team).to(be_a(team_config)) }
  end

  describe 'record_classes' do
    subject { klass.instance }

    it { expect(subject.record_classes).to be_a(Array) }
    it { expect(subject.record_classes).to include(championship_class) }
    it { expect(subject.record_classes).to include(match_class) }
    it { expect(subject.record_classes).to include(ranking_class) }
    it { expect(subject.record_classes).to include(round_class) }
    it { expect(subject.record_classes).to include(team_class) }
    it { expect(subject.record_classes.length).to eq(5) }
  end

  describe 'config_classes' do
    subject { klass.instance }

    it { expect(subject.config_classes).to be_a(Array) }
    it { expect(subject.config_classes).to include(championship_config) }
    it { expect(subject.config_classes).to include(match_config) }
    it { expect(subject.config_classes).to include(ranking_config) }
    it { expect(subject.config_classes).to include(round_config) }
    it { expect(subject.config_classes).to include(team_config) }
    it { expect(subject.config_classes.length).to eq(5) }
  end

  # @note These specs take in account the records and the schema file initialize
  #  before the specs
  #
  describe 'validate' do
    subject { klass.instance }

    describe '!' do
      let(:config_record) { subject.match }

      before do
        subject.championship.config = {
          rename_attrs: { division: :serie }
        }
      end

      it do
        expect { subject.validate! }.to_not(raise_error)
      end
    end

    describe '_attrs_presence!' do
      let(:config_record) { subject.match }

      context 'when valid' do
        it do
          expect { subject.validate_attrs_presence!(config_record) }.to_not(
            raise_error
          )
        end
      end

      context 'when a invalid rename' do
        let(:config_record) { subject.match }
        let(:record_class) { 'Match' }
        let(:undefine_attribute) { 'not_defined' }

        before do
          config_record.config = {
            rename_attrs: {
              id_match: undefine_attribute
            }
          }
        end

        it do
          expect { subject.validate_attrs_presence!(config_record) }.to(
            raise_error(
              ScrapCbfRecord::RecordRenameAttributeNotDefinedError,
              "The record class #{record_class}" \
              " has not defined the renamed attribute #{undefine_attribute}." \
              ' Check if you write the attribute name correct, or' \
              ' if you don\'t want rename,' \
              ' remove it from the config list rename attrs.'
            )
          )
        end
      end

      context 'when a missing or invalid attr' do
        let(:config_record) { subject.match }
        let(:record_class) { 'Game' }
        let(:attribute) { :id_match }

        before do
          # We use the class Game here (is Match but with renamed class
          #  and some attrs) to test a missing attribute. In this case,
          #  Game has id_match renamed to identifier. Because we didn't add it
          #  to config rename_attrs, Game will not recognize id_match.
          #
          config_record.config = {
            class_name: record_class,
            # rename_attrs: { id_match: :identifier },
            exclude_attrs_on_create: %i[serie round updates],
            exclude_attrs_on_update: %i[serie round updates],
            associations: {
              championship: {
                class_name: 'Championship',
                foreign_key: :cup_id
              },
              team: {
                class_name: 'Team',
                foreign_key: :team_opponent_id
              },
              opponent: {
                class_name: 'Team',
                foreign_key: :match_round_id
              }
            }
          }
        end

        it do
          expect do
            subject.validate_attrs_presence!(config_record)
          end.to raise_error(
            ScrapCbfRecord::RecordAttributeNotDefinedError,
            "The record class #{record_class}" \
            " has not defined the attribute #{attribute}." \
            ' If you don\'t want define this attribute,' \
            ' add it to the config lists of excludes on create and update.'
          )
        end
      end
    end

    describe '_record_presence!' do
      let(:config_record) { subject.championship }

      context 'when valid' do
        it do
          expect { subject.validate_record_presence!(config_record) }.to_not(
            raise_error
          )
        end
      end

      context 'when not valid' do
        let(:record_class) { 'NotDefined' }

        before do
          config_record.config = { class_name: record_class }
        end

        it do
          expect { subject.validate_record_presence!(config_record) }.to(
            raise_error(
              ScrapCbfRecord::RecordClassNotDefinedError,
              "The record class #{record_class}" \
              ' was not defined. Check if the class exist or is being loaded'
            )
          )
        end
      end
    end

    describe '_associations_presence!' do
      let(:config_record) { subject.match }

      context 'when valid' do
        it do
          expect do
            subject.validate_associations_presence!(config_record)
          end.to_not(raise_error)
        end
      end

      context 'when not valid' do
        let(:record_class) { 'Match' }
        let(:foreign_key) { 'not_defined' }

        before do
          config_record.config = {
            associations: {
              championship: {
                class_name: 'Championship',
                foreign_key: foreign_key
              }
            }
          }
        end

        it do
          expect do
            subject.validate_associations_presence!(config_record)
          end.to raise_error(
            ScrapCbfRecord::RecordAssociationAttributeNotDefinedError,
            "The record class #{record_class}" \
            " has not defined the attribute #{foreign_key}." \
            ' If you don\'t want define this attribute,' \
            ' remove it from the config associations.'
          )
        end
      end
    end

    describe '_attr_presence_from_rename!' do
      let(:config_record) { subject.match }
      let(:record_instance) { config_record.constant.new }
      let(:attribute) { :id_match }
      let(:rename_attrs) do
        config_record.rename_attrs
      end

      context 'when valid' do
        before do
          config_record.config = {
            # even though we are not renaming the attr here,
            # it still apply as spec for valid
            rename_attrs: {
              id_match: attribute
            }
          }
        end

        it do
          expect do
            subject.validate_attr_presence_from_rename!(
              record_instance,
              attribute,
              rename_attrs
            )
          end.to_not(raise_error)
        end
      end

      context 'when not valid' do
        let(:record_class) { 'Match' }
        let(:undefine_attribute) { 'not_defined' }

        before do
          config_record.config = {
            rename_attrs: {
              id_match: undefine_attribute
            }
          }
        end

        it do
          expect do
            subject.validate_attr_presence_from_rename!(
              record_instance,
              attribute,
              rename_attrs
            )
          end.to raise_error(
            ScrapCbfRecord::RecordRenameAttributeNotDefinedError,
            "The record class #{record_class}" \
            " has not defined the renamed attribute #{undefine_attribute}." \
            ' Check if you write the attribute name correct, or' \
            ' if you don\'t want rename,' \
            ' remove it from the config list rename attrs.'
          )
        end
      end
    end

    describe '_attr_presence_from_exclude!' do
      let(:config_record) { subject.match }
      let(:record_instance) { config_record.constant.new }
      let(:attribute) { :updates }
      let(:exclude_attrs) do
        config_record.exclude_attrs
      end

      context 'when valid' do
        # it is valid because Match has all the record attrs defined
        it do
          expect do
            subject.validate_attr_presence_from_exclude!(
              record_instance,
              attribute,
              exclude_attrs
            )
          end.to_not(raise_error)
        end
      end

      context 'when not valid' do
        let(:record_class) { 'Match' }
        let(:attribute) { 'not_defined' }

        it do
          expect do
            subject.validate_attr_presence_from_exclude!(
              record_instance,
              attribute,
              exclude_attrs
            )
          end.to raise_error(
            ScrapCbfRecord::RecordAttributeNotDefinedError,
            "The record class #{record_class}" \
            " has not defined the attribute #{attribute}." \
            ' If you don\'t want define this attribute,' \
            ' add it to the config lists of excludes on create and update.'
          )
        end
      end
    end
  end
end
