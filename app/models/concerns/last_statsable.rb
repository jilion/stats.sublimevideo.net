require 'mongoid'

module LastStatsable
  extend ActiveSupport::Concern

  included do
    field :lo, as: :loads, type: Integer, default: 0
    field :st, as: :starts, type: Integer, default: 0
  end

  module ClassMethods
    def inc_stat(args, field)
      stat = where(args)
      stat.find_and_modify(
        { :$inc => { database_field_name(field) => 1 } },
        upsert: true,
        new: true
      )
    end
  end
end
