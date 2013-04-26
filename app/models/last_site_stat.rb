class LastSiteStat
  include Mongoid::Document
  include LastStatsable

  field :s, as: :site_token
  field :t, as: :time, type: Time # seconds precision

  index site_token: 1, time: -1
  index({ time: 1 }, expire_after_seconds: 61.minutes.to_i)

  def self.inc_stat(site_token, time, field)
    stat = where(site_token: site_token, time: second_precision(time))
    stat.find_and_modify({
      :$inc => { database_field_name(field) => 1 }
    }, upsert: true, new: true)
  end

  private

  def self.second_precision(time)
    Time.at(time).change(seconds: 0)
  end

end
