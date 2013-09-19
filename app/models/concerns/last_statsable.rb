module LastStatsable
  extend ActiveSupport::Concern

  included do
    field :lo, as: :loads, type: Integer, default: 0
    field :st, as: :starts, type: Integer, default: 0
  end

  module ClassMethods
    def inc_stat(args, field)
      updates = { :$inc => { database_field_name(field) => 1 } }
      args = _minute_precise_time(args)
      self.collection.where(args).upsert(updates)
    end

    private

    def _minute_precise_time(args)
      args['t'] = Time.at(args['t'].to_i).utc.change(sec: 0)
      args
    end

  end
end
