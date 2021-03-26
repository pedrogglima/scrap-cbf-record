# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Rounds do
  # associations must exist for some cases
  let!(:championship) { create(:championship) }

  let(:championship_hash) { attributes_for(:championship_hash) }
  let(:round_hash) { attributes_for(:round_hash) }
  let(:array_rounds) { [round_hash] }

  subject { ScrapCbfRecord::ActiveRecord::Rounds.new(array_rounds) }

  describe 'create_unless_found' do
    context 'using default settings' do
      let(:round) { create(:round, championship_id: championship.id) }

      context 'when not found' do
        before do
          Round.destroy_all
        end

        it do
          expect do
            subject.create_unless_found(championship_hash)
          end.to(change { Round.count }.by(1))
        end
      end

      context 'when found' do
        before do
          round
        end

        it do
          expect do
            subject.create_unless_found(championship_hash)
          end.to(change { Round.count }.by(0))
        end
      end
    end

    context 'using custom settings' do
      context 'renames and exclusion' do
        let(:serie) { create(:round_renamed_serie, cup_id: championship.id) }

        before do
          ScrapCbfRecord.settings do |config|
            config.round.config = {
              class_name: 'Serie',
              rename_attrs: { number: 'identifier' },
              exclude_attrs_on_create: %i[serie],
              exclude_attrs_on_update: %i[],
              associations: {
                championship: {
                  class_name: 'Championship',
                  foreign_key: :cup_id
                }
              }
            }
          end
        end

        context 'when not found' do
          before do
            championship
            Serie.destroy_all
          end

          it do
            expect do
              subject.create_unless_found(championship_hash)
            end.to(change { Serie.count }.by(1))
          end
        end

        context 'when found' do
          before do
            serie
          end

          it do
            expect do
              subject.create_unless_found(championship_hash)
            end.to(change { Serie.count }.by(0))
          end
        end
      end

      # context 'without associations' do
      #   let(:round) { create(:round_without_association) }

      #   before do
      #     ScrapCbfRecord.settings do |config|
      #       config.round.config = {
      #         class_name: 'RoundWithoutAssociation',
      #         rename_attrs: { serie: 'division' },
      #         exclude_attrs_on_create: %i[],
      #         exclude_attrs_on_update: %i[],
      #         associations: {}
      #       }
      #     end
      #   end

      #   context 'when not found' do
      #     before do
      #       championship
      #       RoundWithoutAssociation.destroy_all
      #     end

      #     it do
      #       expect do
      #         subject.create_unless_found(championship_hash)
      #       end.to(change { RoundWithoutAssociation.count }.by(1))
      #     end
      #   end

      #   context 'when found' do
      #     before do
      #       round
      #     end

      #     it do
      #       expect do
      #         subject.create_unless_found(championship_hash)
      #       end.to(change { RoundWithoutAssociation.count }.by(0))
      #     end
      #   end
      # end
    end
  end

  describe 'normalize_before_create' do
    describe 'with association' do
      let(:associations) { attributes_for(:round_hash_associations) }
      let(:normalized) { attributes_for(:round_hash_normalized) }

      before do
        ScrapCbfRecord.settings do |config|
          config.round.config = {
            class_name: 'Serie',
            rename_attrs: { number: 'identifier' },
            exclude_attrs_on_create: %i[],
            exclude_attrs_on_update: %i[],
            associations: {
              championship: {
                class_name: 'Championship',
                foreign_key: :cup_id
              }
            }
          }
        end
      end

      it do
        expect(
          subject.normalize_before_create(
            round_hash,
            associations
          )
        ).to(
          eq(normalized)
        )
      end
    end

    describe 'without association' do
      let(:associations) { attributes_for(:round_hash_without_associations) }
      let(:normalized) do
        attributes_for(:round_hash_normalized_without_association)
      end

      before do
        ScrapCbfRecord.settings do |config|
          config.round.config = {
            class_name: 'RoundWithoutAssociation',
            rename_attrs: { number: 'identifier' },
            exclude_attrs_on_create: %i[],
            exclude_attrs_on_update: %i[],
            associations: {}
          }
        end
      end

      it do
        expect(
          subject.normalize_before_create(
            round_hash,
            associations
          )
        ).to(
          eq(normalized)
        )
      end
    end
  end
end
