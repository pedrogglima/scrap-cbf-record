# frozen_string_literal: true

class ScrapCbfRecord
  # This class helps with the communication between models association
  class ActiveRecordRelation
    # @param [association_class] the class associated that will be searched
    # @param [associate] boolean true if associate, false if it's not
    # @return [ActiveRecordRelation]
    def initialize(association_class, associate)
      @association_class = association_class
      @associate = associate
    end

    # Searchs on the association. Dependes on the associate value,
    #  the search on db will be made if more or less arguments, or none.
    #  be made on database level. If it's not, it may be using
    #
    # @param [attributes] hash contaning the attributes use to search
    # @return [Object] return the obj found on db or their identifier
    def find_by(attributes)
      attributes[:associate] = @associate
      @association_class.send __method__, attributes
    end

    # Searchs on the association. Dependes on the associate value,
    #  the search on db will be made if more or less arguments, or none.
    #  be made on database level. If it's not, it may be using
    #
    # @note Raises a exception if not found
    # @param [attributes] hash contaning the attributes use to search
    # @return [Object] return the obj found on db or their identifier
    def find_by!(attributes)
      attributes[:associate] = @associate
      @association_class.send __method__, attributes
    end
  end
end
