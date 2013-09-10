module LastDaysStartsFindable
  extend ActiveSupport::Concern

  included do

    scope :last_days, ->(days) {
      from = Time.now.utc.at_beginning_of_day - days.days
      to   = Time.now.utc.end_of_day - 1.day
      between(time: from..to)
    }

  end

  module ClassMethods

    def last_days_starts(args, days)
      stats = where(args).last_days(days).only(:time, :starts).asc(:time)
      stats.present? ? _group_starts_by_days(stats, days) : days.times.map { 0 }
    end

    private

    def _group_starts_by_days(stats, days)
      days_stats = stats.group_by { |stat| stat.time.at_beginning_of_day }
      days_starts = days_stats.values.map { |stats| stats.sum(&:starts_sum) }
      days_starts = days_starts.unshift(0) until days_starts.size == days
      days_starts
    end

  end

  def starts_sum
    starts.values.sum
  end

end
