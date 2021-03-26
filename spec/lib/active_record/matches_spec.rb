# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Matches do
  # associations must exist for some cases
  let!(:championship) { create(:championship) }
  let!(:round) { create(:round, championship_id: championship.id) }
  let!(:team) { create(:team) }
  let!(:opponent) { create(:team_opponent) }

  let(:championship_hash) { attributes_for(:championship_hash) }
  let(:match_hash) { attributes_for(:match_hash) }
  let(:array_matches) { [match_hash] }

  subject { ScrapCbfRecord::ActiveRecord::Matches.new(array_matches) }

  describe 'create_or_update' do
    describe 'create_or_update' do
      context 'using default settings' do
        context 'when there aren\'t matches' do
          before do
            Match.destroy_all
          end

          it do
            expect do
              subject.create_or_update(championship_hash)
            end.to(change { Match.count }.by(1))
          end
        end

        context 'when there are matches' do
          let(:match_hash) do
            attributes_for(:match_hash, team_score: 2)
          end
          let(:array_matches) { [match_hash] }
          let(:match) do
            create(
              :match,
              championship_id: championship.id,
              round_id: round.id,
              team_id: team.id,
              opponent_id: opponent.id,
              team_score: 1
            )
          end

          before do
            Match.destroy_all
          end

          it 'expect to update attribute' do
            match # create before update

            subject.create_or_update(championship_hash)
            expect(match.reload.team_score).to(eq(2))
          end
        end
      end

      context 'using custom settings' do
        context 'renames and exclusions' do
          context 'when there aren\'t matchs' do
            before do
              Game.destroy_all

              ScrapCbfRecord.settings do |config|
                config.match.config = {
                  class_name: 'Game',
                  rename_attrs: { id_match: 'identifier' },
                  exclude_attrs_on_create: %i[serie],
                  exclude_attrs_on_update: %i[serie],
                  associations: {
                    championship: {
                      class_name: 'Championship',
                      foreign_key: :cup_id
                    },
                    round: {
                      class_name: 'Round',
                      foreign_key: :round_id
                    },
                    team: {
                      class_name: 'Team',
                      foreign_key: :team_id
                    },
                    opponent: {
                      class_name: 'Team',
                      foreign_key: :opponent_id
                    }
                  }
                }
              end
            end

            it do
              expect do
                subject.create_or_update(championship_hash)
              end.to(change { Game.count }.by(1))
            end
          end

          context 'when there are matchs' do
            let(:match_hash) do
              attributes_for(:match_hash, team_score: 2)
            end
            let(:array_matchs) { [match_hash] }
            let(:game) do
              create(
                :match_renamed_game,
                cup_id: championship.id,
                round_id: round.id,
                team_id: team.id,
                opponent_id: opponent.id,
                team_score: 1
              )
            end

            before do
              Game.destroy_all

              ScrapCbfRecord.settings do |config|
                config.match.config = {
                  class_name: 'Game',
                  rename_attrs: { id_match: 'identifier' },
                  exclude_attrs_on_create: %i[serie],
                  exclude_attrs_on_update: %i[serie],
                  associations: {
                    championship: {
                      class_name: 'Championship',
                      foreign_key: :cup_id
                    },
                    round: {
                      class_name: 'Round',
                      foreign_key: :round_id
                    },
                    team: {
                      class_name: 'Team',
                      foreign_key: :team_id
                    },
                    opponent: {
                      class_name: 'Team',
                      foreign_key: :opponent_id
                    }
                  }
                }
              end
            end

            it 'expect to update attribute' do
              game # create before update

              subject.create_or_update(championship_hash)
              expect(game.reload.team_score).to(eq(2))
            end
          end
        end

        context 'without associations' do
          context 'when there aren\'t matchs' do
            before do
              MatchWithoutAssociation.destroy_all

              ScrapCbfRecord.settings do |config|
                config.match.config = {
                  class_name: 'MatchWithoutAssociation',
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
              end.to(change { MatchWithoutAssociation.count }.by(1))
            end
          end

          context 'when there are matchs' do
            let(:match_hash) do
              attributes_for(:match_hash, team_score: 2)
            end
            let(:array_matchs) { [match_hash] }
            let(:match_without_association) do
              create(:match_without_association, team_score: 1)
            end

            before do
              MatchWithoutAssociation.destroy_all

              ScrapCbfRecord.settings do |config|
                config.match.config = {
                  class_name: 'MatchWithoutAssociation',
                  rename_attrs: {},
                  exclude_attrs_on_create: %i[],
                  exclude_attrs_on_update: %i[],
                  associations: {}
                }
              end
            end

            it 'expect to update attribute' do
              match_without_association # create before update

              subject.create_or_update(championship_hash)
              expect(match_without_association.reload.team_score).to(eq(2))
            end
          end
        end
      end
    end
  end

  describe 'normalize_before_' do
    context 'create' do
      describe 'with association' do
        let(:associations) { attributes_for(:match_hash_associations) }
        let(:normalized) { attributes_for(:match_hash_normalized) }

        before do
          ScrapCbfRecord.settings do |config|
            config.match.config = {
              class_name: 'Game',
              rename_attrs: { id_match: 'identifier' },
              exclude_attrs_on_create: %i[serie],
              exclude_attrs_on_update: %i[],
              associations: {
                championship: {
                  class_name: 'Championship',
                  foreign_key: :cup_id
                },
                round: {
                  class_name: 'Round',
                  foreign_key: :round_id
                },
                team: {
                  class_name: 'Team',
                  foreign_key: :team_id
                },
                opponent: {
                  class_name: 'Team',
                  foreign_key: :opponent_id
                }
              }
            }
          end
        end

        it do
          expect(
            subject.normalize_before_create(
              match_hash,
              associations
            )
          ).to(
            eq(normalized)
          )
        end
      end

      describe 'without association' do
        let(:associations) do
          attributes_for(:match_hash_without_associations)
        end
        let(:normalized) do
          attributes_for(:match_hash_normalized_without_association)
        end

        before do
          ScrapCbfRecord.settings do |config|
            config.match.config = {
              class_name: 'MatchWithoutAssociation',
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
              match_hash,
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
        let(:associations) { attributes_for(:match_hash_associations) }
        let(:normalized) { attributes_for(:match_hash_normalized) }

        before do
          ScrapCbfRecord.settings do |config|
            config.match.config = {
              class_name: 'Game',
              rename_attrs: { id_match: 'identifier' },
              exclude_attrs_on_create: %i[],
              exclude_attrs_on_update: %i[serie],
              associations: {
                championship: {
                  class_name: 'Championship',
                  foreign_key: :cup_id
                },
                round: {
                  class_name: 'Round',
                  foreign_key: :round_id
                },
                team: {
                  class_name: 'Team',
                  foreign_key: :team_id
                },
                opponent: {
                  class_name: 'Team',
                  foreign_key: :opponent_id
                }
              }
            }
          end
        end

        it do
          expect(
            subject.normalize_before_update(
              match_hash,
              associations
            )
          ).to(
            eq(normalized)
          )
        end
      end

      describe 'without association' do
        let(:associations) { attributes_for(:match_hash_without_associations) }
        let(:normalized) do
          attributes_for(:match_hash_normalized_without_association)
        end

        before do
          ScrapCbfRecord.settings do |config|
            config.match.config = {
              class_name: 'MatchWithoutAssociation',
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
              match_hash,
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
