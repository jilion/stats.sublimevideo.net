require 'mongoid'

require 'video_identifiable'
require 'hourly_expirable'
require 'last_statsable'

class LastVideoStat
  include Mongoid::Document
  include VideoIdentifiable
  include HourlyExpirable
  include LastStatsable
end
