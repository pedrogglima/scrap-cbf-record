# frozen_string_literal: true

class ScrapCbfRecord
  module ActiveRecord
    def save(records)
      Record.new(records).save
    end
  end
end
