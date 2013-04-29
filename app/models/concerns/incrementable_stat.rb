require 'mongoid'

module IncrementableStat
  extend ActiveSupport::Concern

  module ClassMethods

    def inc_stat(args, field)
      args = precise_time(args)
      stat = where(args)
      stat.find_and_modify({
        :$inc => { database_field_name(field) => 1 }
      }, upsert: true, new: true)
    end

    private

    def precise_time(args)
      args[:time] = Time.at(args[:time]).change(time_precision)
      args
    end

    def time_precision
      nil
    end

  end
end
