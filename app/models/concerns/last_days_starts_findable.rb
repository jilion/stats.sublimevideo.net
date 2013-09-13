module LastDaysStartsFindable
  extend ActiveSupport::Concern

  module ClassMethods

    def last_days_starts(args, days)
      range = _last_days_range(days)
      stats = where(args).between(time: range).only(:time, :starts).asc(:time)
      _group_starts_by_days(stats, range)
    end

    private

    def _group_starts_by_days(stats, range)
      days_stats = stats.group_by { |stat| stat.time.to_date }
      (range.first.to_date..range.last.to_date).map do |day|
        days_stats[day].to_a.sum { |stats| stats.starts_sum }
      end
    end

    def _last_days_range(days)
      from = Time.now.utc.at_beginning_of_day - days.days
      to   = Time.now.utc.end_of_day - 1.day
      from..to
    end

  end

  def starts_sum
    starts.try(:values).to_a.sum
  end

end
