require 'mongoid'

require 'hourly_expirable'
require 'last_statsable'
require 'incrementable_stat'

class LastVideoStat
  include Mongoid::Document
  include HourlyExpirable
  include LastStatsable
  include IncrementableStat

  field :s, as: :site_token
  field :u, as: :video_uid
  field :t, as: :time, type: Time # seconds precision
  index site_token: 1, video_uid: 1, time: -1

  def self.time_precision
    { seconds: 0 }
  end
end
