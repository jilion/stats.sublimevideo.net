require 'mongoid'

require 'last_statsable'
require 'incrementable_stat'

class LastSiteStat
  include Mongoid::Document
  include LastStatsable
  include IncrementableStat

  field :s, as: :site_token
  field :t, as: :time, type: Time # seconds precision

  index site_token: 1, time: -1
  index({ time: 1 }, expire_after_seconds: 61.minutes.to_i)

  def self.time_precision
    { seconds: 0 }
  end
end
