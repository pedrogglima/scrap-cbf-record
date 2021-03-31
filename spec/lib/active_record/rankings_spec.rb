# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Rankings do
  # associations must exist for some cases
  let!(:championship) { create(:championship) }
  let!(:team) { create(:team) }
  let!(:next_opponent) { create(:team_opponent) }

  let(:championship_hash) { attributes_for(:championship_hash) }
  let(:ranking_hash) { attributes_for(:ranking_hash) }
  let(:array_rankings) { [ranking_hash] }

  subject { ScrapCbfRecord::ActiveRecord::Rankings.new(array_rankings) }

  describe 'create_or_update' do
    context 'using default settings' do
      context 'when there aren\'t rankings' do
        before do
          Ranking.destroy_all
        end

        it do
          expect do
            subject.create_or_update(championship_hash)
          end.to(change { Ranking.count }.by(1))
        end
      end

      context 'when there are rankings' do
        let(:ranking_hash) do
          attributes_for(:ranking_hash, points: 20)
        end
        let(:array_rankings) { [ranking_hash] }
        let(:ranking) do
          create(
            :ranking,
            championship_id: championship.id,
            team_id: team.id,
            next_opponent_id: next_opponent.id,
            points: 20
          )
        end

        before do
          Ranking.destroy_all
        end

        it 'expect to update attribute' do
          ranking # create before update

          subject.create_or_update(championship_hash)
          expect(ranking.reload.points).to(eq(20))
        end
      end
    end

    context 'using custom settings' do
      context 'renames and exclusions' do
        context 'when there aren\'t rankings' do
          before do
            TableRow.destroy_all

            ScrapCbfRecord.settings do |config|
              config.ranking.config = {
                class_name: 'TableRow',
                rename_attrs: { position: 'rank' },
                exclude_attrs_on_create: %i[
                  serie
                  goals_for
                  goals_against
                  goal_difference
                  yellow_card
                  red_card
                ],
                exclude_attrs_on_update: %i[
                  serie
                  goals_for
                  goals_against
                  goal_difference
                  yellow_card
                  red_card
                ],
                associations: {
                  championship: {
                    class_name: 'Championship',
                    foreign_key: :cup_id
                  },
                  team: {
                    class_name: 'Team',
                    foreign_key: :rank_team_id
                  },
                  next_opponent: {
                    class_name: 'Team',
                    foreign_key: :next_team_opponent_id
                  }
                }
              }
            end
          end

          it do
            expect do
              subject.create_or_update(championship_hash)
            end.to(change { TableRow.count }.by(1))
          end
        end

        context 'when there are rankings' do
          let(:ranking_hash) do
            attributes_for(:ranking_hash, points: 20)
          end
          let(:array_rankings) { [ranking_hash] }
          let(:table_row) do
            create(
              :ranking_renamed_table_row,
              cup_id: championship.id,
              rank_team_id: team.id,
              next_team_opponent_id: next_opponent.id,
              points: 10
            )
          end

          before do
            TableRow.destroy_all

            ScrapCbfRecord.settings do |config|
              config.ranking.config = {
                class_name: 'TableRow',
                rename_attrs: { position: 'rank' },
                exclude_attrs_on_create: %i[
                  serie
                  goals_for
                  goals_against
                  goal_difference
                  yellow_card
                  red_card
                ],
                exclude_attrs_on_update: %i[
                  serie
                  serie
                  goals_for
                  goals_against
                  goal_difference
                  yellow_card
                  red_card
                ],
                associations: {
                  championship: {
                    class_name: 'Championship',
                    foreign_key: :cup_id
                  },
                  team: {
                    class_name: 'Team',
                    foreign_key: :rank_team_id
                  },
                  next_opponent: {
                    class_name: 'Team',
                    foreign_key: :next_team_opponent_id
                  }
                }
              }
            end
          end

          it 'expect to update attribute' do
            table_row # create before update

            subject.create_or_update(championship_hash)
            expect(table_row.reload.points).to(eq(20))
          end
        end
      end

      context 'without associations' do
        context 'when there aren\'t rankings' do
          before do
            RankingWithoutAssociation.destroy_all

            ScrapCbfRecord.settings do |config|
              config.ranking.config = {
                class_name: 'RankingWithoutAssociation',
                rename_attrs: {},
                exclude_attrs_on_create: %i[],
                exclude_attrs_on_update: %i[],
                associations: {}
              }
            end
          end

          it do
            expect do
              subject.create_or_update(championship_hash)
            end.to(change { RankingWithoutAssociation.count }.by(1))
          end
        end

        context 'when there are rankings' do
          let(:ranking_hash) do
            attributes_for(:ranking_hash, points: 20)
          end
          let(:array_rankings) { [ranking_hash] }
          let(:ranking_without_association) do
            create(:ranking_without_association, points: 20)
          end

          before do
            RankingWithoutAssociation.destroy_all

            ScrapCbfRecord.settings do |config|
              config.ranking.config = {
                class_name: 'RankingWithoutAssociation',
                rename_attrs: {},
                exclude_attrs_on_create: %i[],
                exclude_attrs_on_update: %i[],
                associations: {}
              }
            end
          end

          it 'expect to update attribute' do
            ranking_without_association # create before update

            subject.create_or_update(championship_hash)
            expect(ranking_without_association.reload.points).to(eq(20))
          end
        end
      end
    end

    # Raised when ActiveRecord method valid? is false before saving
    context 'when record is invalid' do
      let(:invalid_hash) { attributes_for(:invalid_ranking_hash) }

      subject { ScrapCbfRecord::ActiveRecord::Rankings.new([invalid_hash]) }

      before do
        ScrapCbfRecord.settings do |config|
          config.ranking.config = {
            class_name: 'RankingWithValidation'
          }
        end

        Ranking.destroy_all
      end

      it do
        expect do
          subject.create_or_update(championship_hash)
        end.to(raise_error ScrapCbfRecord::ActiveRecordValidationError)
      end
    end
  end

  describe 'normalize_before_' do
    context 'create' do
      describe 'with association' do
        let(:associations) { attributes_for(:ranking_hash_associations) }
        let(:normalized) { attributes_for(:ranking_hash_normalized) }

        before do
          ScrapCbfRecord.settings do |config|
            config.ranking.config = {
              class_name: 'TableRow',
              rename_attrs: { position: 'rank' },
              exclude_attrs_on_create: %i[
                serie
                goals_for
                goals_against
                goal_difference
                yellow_card
                red_card
              ],
              exclude_attrs_on_update: %i[
                serie
                goals_for
                goals_against
                goal_difference
                yellow_card
                red_card
              ],
              associations: {
                championship: {
                  class_name: 'Championship',
                  foreign_key: :cup_id
                },
                team: {
                  class_name: 'Team',
                  foreign_key: :rank_team_id
                },
                next_opponent: {
                  class_name: 'Team',
                  foreign_key: :next_team_opponent_id
                }
              }
            }
          end
        end

        it do
          expect(
            subject.normalize_before_create(
              ranking_hash,
              associations
            )
          ).to(
            eq(normalized)
          )
        end
      end

      describe 'without association' do
        let(:associations) do
          attributes_for(:ranking_hash_without_associations)
        end
        let(:normalized) do
          attributes_for(:ranking_hash_normalized_without_association)
        end

        before do
          ScrapCbfRecord.settings do |config|
            config.ranking.config = {
              class_name: 'RankingWithoutAssociation',
              rename_attrs: {},
              exclude_attrs_on_create: %i[],
              exclude_attrs_on_update: %i[],
              associations: {}
            }
          end
        end

        it do
          expect(
            subject.normalize_before_create(
              ranking_hash,
              associations
            )
          ).to(
            eq(normalized)
          )
        end
      end
    end

    context 'update' do
      describe 'with association' do
        let(:associations) { attributes_for(:ranking_hash_associations) }
        let(:normalized) { attributes_for(:ranking_hash_normalized) }

        before do
          ScrapCbfRecord.settings do |config|
            config.ranking.config = {
              class_name: 'TableRow',
              rename_attrs: { position: 'rank' },
              exclude_attrs_on_create: %i[
                serie
                goals_for
                goals_against
                goal_difference
                yellow_card
                red_card
              ],
              exclude_attrs_on_update: %i[
                serie
                goals_for
                goals_against
                goal_difference
                yellow_card
                red_card
              ],
              associations: {
                championship: {
                  class_name: 'Championship',
                  foreign_key: :cup_id
                },
                team: {
                  class_name: 'Team',
                  foreign_key: :rank_team_id
                },
                next_opponent: {
                  class_name: 'Team',
                  foreign_key: :next_team_opponent_id
                }
              }
            }
          end
        end

        it do
          expect(
            subject.normalize_before_update(
              ranking_hash,
              associations
            )
          ).to(
            eq(normalized)
          )
        end
      end

      describe 'without association' do
        let(:associations) do
          attributes_for(:ranking_hash_without_associations)
        end
        let(:normalized) do
          attributes_for(:ranking_hash_normalized_without_association)
        end

        before do
          ScrapCbfRecord.settings do |config|
            config.ranking.config = {
              class_name: 'RankingWithoutAssociation',
              rename_attrs: {},
              exclude_attrs_on_create: %i[],
              exclude_attrs_on_update: %i[],
              associations: {}
            }
          end
        end

        it do
          expect(
            subject.normalize_before_update(
              ranking_hash,
              associations
            )
          ).to(
            eq(normalized)
          )
        end
      end
    end
  end
end
