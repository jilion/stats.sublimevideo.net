require 'mongoid'

require 'video_identifiable'
require 'yearly_expirable'
require 'statsable'
require 'last_hours_findable'
require 'last_days_starts_findable'

class VideoStat
  include Mongoid::Document
  include VideoIdentifiable
  include YearlyExpirable
  include Statsable
  include LastHoursFindable
  include LastDaysStartsFindable
end
