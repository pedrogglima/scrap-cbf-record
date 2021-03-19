# frozen_string_literal: true

RSpec.describe ScrapCbfRecord do
  it 'has a version number' do
    expect(ScrapCbfRecord::VERSION).not_to be nil
  end

  describe 'class methods' do
    describe 'config' do
      context 'when is not set should default to' do
        it { expect(ScrapCbfRecord.config).to be_a(ScrapCbfRecord::Config) }
      end

      context 'when is set' do
        # constant must be declared before hand settings
        let!(:soccer_team_class) do
          class SoccerTeam
            def self.find_by(_name)
              true
            end
          end
        end

        before do
          ScrapCbfRecord.record_settings do |config|
            config.team_class = 'SoccerTeam'
          end
        end

        it do
          expect(ScrapCbfRecord.config.team_class).to(
            eq('SoccerTeam')
          )
        end
      end
    end
  end
end
