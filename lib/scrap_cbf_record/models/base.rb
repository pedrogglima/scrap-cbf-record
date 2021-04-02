# frozen_string_literal: true

class ScrapCbfRecord
  # Represents the class Championship
  class Base
    class << self
      # Create a instance for the real model, the one used by the user
      #
      # @param [args] arguments passed to new instance
      # @return [Object] the instance model
      def new(args)
        @config.klass.new(args)
      end
    end
  end
end
