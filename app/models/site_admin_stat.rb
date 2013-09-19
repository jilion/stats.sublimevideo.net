require 'mongoid'

require 'site_identifiable'

class SiteAdminStat
  include Mongoid::Document
  include SiteIdentifiable

  field :al, as: :app_loads, type: Hash # { m(main): 1, e(extra): 3, s(staging): 5, d(dev): 11, i(invalid): 1 }
  field :lo, as: :loads, type: Hash # { w(website): 3, e(external): 9 }, even without video_uid
  field :st, as: :starts, type: Hash # { w(website): 3, e(external): 9 }, even without video_uid
  field :sa, as: :stages, type: Array # Stages used this day
  field :ss, as: :ssl, type: Mongoid::Boolean # SSL used this day
  field :pa, as: :pages, type: Array # Last 10 active pages

  scope :last_days, ->(days) {
    from = Time.now.utc.at_beginning_of_day - days.days
    to   = Time.now.utc.end_of_day - 1.day
    between(time: from..to)
  }

  def self.update_stats(args, updates)
    args = _day_precise_time(args)
    stat = where(args)
    stat.find_and_modify(updates, upsert: true, new: false)
  end

  def self.last_pages(site_token, days: 30, limit: 10)
    stats = self.where(site_token: site_token, time: { :$gte => days.days.ago })
    scored_pages = stats.inject(Hash.new(0)) { |pages, stat|
      stat.pages.each { |p| pages[p] += 1 }
      pages }
    pages = scored_pages.keys.sort { |a, b| scored_pages[b] <=> scored_pages[a] }
    pages.shift(limit)
  end

  def self.last_without_pages(site_token)
    where(site_token: site_token, pages: nil).order_by(time: :desc).first
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
    args[:time] = Time.at(args[:time]).utc.change(hour: 0)
    args
  end
end
