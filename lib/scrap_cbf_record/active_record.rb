# frozen_string_literal: true

class ScrapCbfRecord
  class ActiveRecord
    def self.save(records)
      Record.new(records).save

      true
    end
  end
end
