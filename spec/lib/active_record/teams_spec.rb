# frozen_string_literal: true

RSpec.describe ScrapCbfRecord::ActiveRecord::Teams do
  let(:team_hash) { attributes_for(:team_hash) }
  let(:array_teams) { [team_hash] }

  subject { ScrapCbfRecord::ActiveRecord::Teams.new(array_teams) }

  describe 'create_unless_found' do
    context 'using default settings' do
      let(:team) { create(:team) }

      context 'when not found' do
        before do
          Team.destroy_all
        end

        it do
          expect do
            subject.create_unless_found
          end.to(change { Team.count }.by(1))
        end
      end

      context 'when found' do
        before do
          team
        end

        it do
          expect do
            subject.create_unless_found
          end.to(change { Team.count }.by(0))
        end
      end
    end

    context 'using custom settings' do
      let(:club) { create(:team_renamed_club) }

      before do
        ScrapCbfRecord.settings do |config|
          config.team.config = {
            class_name: 'Club',
            rename_attrs: { name: 'club_name', avatar_url: 'club_flag_url' },
            exclude_attrs_on_create: %i[state],
            exclude_attrs_on_update: %i[],
            associations: {}
          }
        end
      end

      context 'when not found' do
        before do
          Club.destroy_all
        end

        it do
          expect do
            subject.create_unless_found
          end.to(change { Club.count }.by(1))
        end
      end

      context 'when found' do
        before do
          club
        end

        it do
          expect do
            subject.create_unless_found
          end.to(change { Club.count }.by(0))
        end
      end
    end
  end

  describe 'normalize_before_create' do
    let(:club) { create(:team_renamed_club) }
    let(:normalized) { attributes_for(:team_hash_normalized) }

    before do
      ScrapCbfRecord.settings do |config|
        config.team.config = {
          class_name: 'Club',
          rename_attrs: { name: 'club_name', avatar_url: 'club_flag_url' },
          exclude_attrs_on_create: %i[state],
          exclude_attrs_on_update: %i[],
          associations: {}
        }
      end
    end

    it do
      expect(subject.normalize_before_create(team_hash)).to(
        eq(normalized)
      )
    end
  end
end
