require 'mongoid'

require 'site_identifiable'
require 'statsable'
require 'last_days_starts_findable'

class SiteStat
  include Mongoid::Document
  include SiteIdentifiable
  include Statsable
  include LastHoursFindable
  include LastDaysStartsFindable
end
