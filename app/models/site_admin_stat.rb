require 'mongoid'

require 'site_identifiable'

class SiteAdminStat
  include Mongoid::Document
  include SiteIdentifiable

  field :al, as: :app_loads, type: Hash # { m(main): 1, e(extra): 3, s(staging): 5, d(dev): 11, i(invalid): 1 }
  field :lo, as: :loads, type: Hash # { w(website): 3, e(external): 9 }, even without video_uid
  field :st, as: :starts, type: Hash # { w(website): 3, e(external): 9 }, even without video_uid
  field :sa, as: :stage, type: Array # Stages used this day
  field :ss, as: :ssl, type: Mongoid::Boolean # SSL used this day

  def self.update_stats(args, updates)
    args = _day_precise_time(args)
    stat = where(args)
    stat.find_and_modify(
      updates,
      upsert: true,
      new: true)
  end

  private

  def self._day_precise_time(args)
    args[:time] = Time.at(args[:time]).change(hour: 0)
    args
  end
end
