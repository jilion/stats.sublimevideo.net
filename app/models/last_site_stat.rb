require 'mongoid'

require 'site_identifiable'
require 'hourly_expirable'
require 'last_statsable'

class LastSiteStat
  include Mongoid::Document
  include SiteIdentifiable
  include HourlyExpirable
  include LastStatsable
end
