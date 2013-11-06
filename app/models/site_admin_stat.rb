require 'mongoid'

require 'site_identifiable'
require 'last_days_starts_findable'

class SiteAdminStat
  include Mongoid::Document
  include SiteIdentifiable
  include LastDaysStartsFindable

  field :al, as: :app_loads, type: Hash, default: {} # { m(main): 1, e(extra): 3, s(staging): 5, d(dev): 11, i(invalid): 1 }
  field :lo, as: :loads, type: Hash, default: {} # { w(website): 3, e(external): 9 }, even without video_uid
  field :st, as: :starts, type: Hash, default: {} # { w(website): 3, e(external): 9 }, even without video_uid
  field :sa, as: :stages, type: Array # Stages used this day
  field :ss, as: :ssl, type: Mongoid::Boolean # SSL used this day
  field :pa, as: :pages, type: Array # Last 10 active pages

  scope :last_days, ->(days) {
    from = Time.now.utc.at_beginning_of_day - days.days
    to   = Time.now.utc.end_of_day - 1.day
    between(time: from..to)
  }

  def self.upsert_stats(args, updates)
    args = _day_precise_time(args)
    self.collection.where(args).upsert(updates)
  end

  def self.last_pages(site_token, days: 30, limit: 10)
    stats = self.where(site_token: site_token, time: { :$gte => days.days.ago })
    scored_pages = stats.inject(Hash.new(0)) { |pages, stat|
      stat.pages.each { |p| pages[p] += 1 } if stat.pages.present?
      pages }
    pages = scored_pages.keys.sort { |a, b| scored_pages[b] <=> scored_pages[a] }
    pages.shift(limit)
  end

  def self.last_without_pages(site_token)
    where(site_token: site_token, pages: nil).order_by(time: :desc).first
  end

  def self.global_day_stat(day, fields)
    where(time: date_to_utc_time(day)).all.inject(self.new) do |global_stat, stat|
      _merge_stat(global_stat, stat, fields)
    end
  end

  def self.last_30_days_sites_with_starts(day, threshold: 100)
    time = date_to_utc_time(day)
    between(time: (time - 29.days)..time.end_of_day)
    .where("((this.st.w || 0) + (this.st.e || 0)) >= #{threshold.to_i}")
    .distinct(:site_token)
    .count
  end

  def self.migration_totals(site_token, day)
    stat = where(site_token: site_token, time: day).first
    { app_loads: stat.app_loads.values.sum,
      loads: stat.loads.values.sum,
      starts: stat.starts.values.sum }
  end

  def stages
    read_attribute(:sa).map do |stage|
      case stage
      when 'a' then 'alpha'
      when 'b' then 'beta'
      when 's' then 'stable'
      end
    end
  end

  private

  def self._day_precise_time(args)
    args['t'] = Time.at(args['t'].to_i).utc.change(hour: 0)
    args
  end

  def self._merge_stat(stat, other_stat, fields)
    fields.each do |field|
      stat.send "#{field}=", stat.send(field).merge(other_stat.send(field)) { |k, old_v, new_v| old_v + new_v }
    end
    stat
  end

  def self.date_to_utc_time(date)
    Time.utc(date.year, date.month, date.day)
  end
end
