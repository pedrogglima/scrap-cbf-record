# frozen_string_literal: true

class ScrapCbfRecord
  # Represents the class Team
  class Team < Base
    class << self
      attr_accessor :config

      def find_by(attributes)
        name         = attributes[:name]
        associate    = attributes[:associate]

        # if associate is nil, that means self is calling this method
        if associate.nil? || associate
          @config.klass.find_by("#{@config.searchable_attr(:name)}": name)
        else
          name
        end
      end
    end
  end
end
