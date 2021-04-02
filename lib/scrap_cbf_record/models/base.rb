# frozen_string_literal: true

class ScrapCbfRecord
  # Represents the class Championship
  class Base
    class << self
      def new(args)
        @config.klass.new(args)
      end
    end
  end
end
