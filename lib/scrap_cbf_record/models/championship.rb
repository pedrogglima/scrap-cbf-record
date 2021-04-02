# frozen_string_literal: true

class ScrapCbfRecord
  # Represents the class Championship
  class Championship
    class << self
      attr_accessor :config

      def find_by!(attributes)
        year         = attributes[:year]
        associate    = attributes[:associate]

        # if associate is nil, that means self is calling this method
        instance = if associate.nil? || associate
                     @config.klass.find_by(
                       "#{@config.searchable_attr(:year)}": year
                     )
                   else
                     year
                   end

        raise ChampionshipInstanceNotFoundError, year unless instance

        instance
      end
    end
  end
end
