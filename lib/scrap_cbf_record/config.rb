# frozen_string_literal: true

class ScrapCbfRecord
  class Config
    RECORD_CLASSES = %i[
      championship
      match
      ranking
      round
      team
    ].freeze

    attr_accessor :championship_class,
                  :match_class,
                  :ranking_class,
                  :round_class,
                  :team_class

    # @return [ScrapCbfRecord::Config]
    def initialize
      set_default_classes_names

      # This method create attr_readers.
      # These attrs return classes using the value in <class_name>_class.
      #
      # def match_const
      #  Object.const_get(@match_class)
      # end
      #
      # @!method championship_const
      # @return [Championship or <CustomName>]
      # @!method match_const
      # @return [Match or <CustomName>]
      # @!method ranking_const
      # @return [Ranking or <CustomName>]
      # @!method round_const
      # @return [Round or <CustomName>]
      # @!method team_const
      # @return [Team or <CustomName>]
      define_class_const_methods
    end

    # Validates all <class_name>_class methods.
    # Two validations are made:
    # - If argument passed is a String or Symbol.
    # - If class is declared.
    #
    # @raise [ArgumentError] if argument is wrong type.
    # @raise [NameError] if class is not declared.
    #
    # @return [nil]
    def validate
      RECORD_CLASSES.each do |class_name|
        class_name_validation(class_name)
      end

      nil
    end

    # Define default names for the <class_name>_class attr_accessors.
    # The default names are found in Config::RECORD_CLASSES.
    #
    # @return [nil]
    def set_default_classes_names
      RECORD_CLASSES.each do |class_name|
        var_name = "@#{class_name}_class"
        instance_variable_set(var_name, class_name.to_s.capitalize)
      end

      nil
    end

    # Return an array with all record classes
    #
    # @return [Array]
    def record_classes
      [
        championship_const,
        match_const,
        ranking_const,
        round_const,
        team_const
      ]
    end

    private

    def define_class_const_methods
      RECORD_CLASSES.each do |class_name|
        define_singleton_method :"#{class_name}_const" do
          defined_class_name = instance_variable_get("@#{class_name}_class")
          Object.const_get(defined_class_name)
        end
      end
    end

    def class_name_validation(class_name)
      unless string?(instance_variable_get("@#{class_name}_class"))
        raise ::ArgumentError,
              'Invalid type: class name must be a string or a symbol'
      end

      begin
        send("#{class_name}_const")
      rescue ::NameError
        raise_custom_name_error(class_name)
      end
    end

    def raise_custom_name_error(class_name)
      raise ::NameError, "uninitialized constant #{class_name}. " \
        'the classes needed by this gem need to be declared (see doc).'
    end

    def string?(var)
      !var.nil? && (var.is_a?(String) || var.is_a?(Symbol))
    end
  end
end
