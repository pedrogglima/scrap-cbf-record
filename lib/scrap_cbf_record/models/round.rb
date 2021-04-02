# frozen_string_literal: true

class ScrapCbfRecord
  # Represents the class Round
  class Round
    class << self
      attr_accessor :config

      def championship
        ActiveRecordRelation.new(
          Championship,
          @config.championship_associate?
        )
      end

      def find_by(attributes)
        number       = attributes[:number]
        championship = attributes[:championship]
        serie        = attributes[:serie]
        associate    = attributes[:associate]

        # if associate is nil, that means self is calling this method
        if associate.nil? || associate
          find_round_on_database(number, championship, serie)
        else
          number
        end
      end

      def find_round_on_database(number, championship, serie)
        if @config.championship_associate?
          find_round_associated(number, championship)
        else
          find_round(number, championship, serie)
        end
      end

      def find_round(number, championship, serie)
        @config.klass.find_by(
          "#{@config.searchable_attr(:number)}": number,
          "#{@config.searchable_attr(:championship)}": championship,
          "#{@config.searchable_attr(:serie)}": serie
        )
      end

      def find_round_associated(number, championship)
        @config.klass.find_by(
          "#{@config.searchable_attr(:number)}": number,
          "#{@config.searchable_attr(:championship_id)}": championship.id
        )
      end
    end
  end
end
