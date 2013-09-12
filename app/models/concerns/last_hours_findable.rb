module LastHoursFindable
  extend ActiveSupport::Concern

  included do

    scope :last_hours, ->(hours) {
      from = Time.now.utc - (hours + 1).hours
      to   = Time.now.utc - 1.hour
      between(time: from..to)
    }

  end

  module ClassMethods

    def last_hours_stats(args, hours)
      where(args).last_hours(hours).asc(:time).all
    end

  end

end
